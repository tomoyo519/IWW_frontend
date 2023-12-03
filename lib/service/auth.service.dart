import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/model/todo/todo_today_count.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:uni_links/uni_links.dart';

class AuthService extends ChangeNotifier {
  final UserRepository userRepository;
  AuthService(this.userRepository);

  // =============== //
  //      Status     //
  // =============== //
  UserModel? _user;
  UserModel? get user => _user;

  Item? _mainPet;
  Item? get mainPet => _mainPet;

  TodoTodayCount? _todayCount;
  TodoTodayCount? get todayCount => _todayCount;

  String? _kakaoId;
  String? get kakaoId => _kakaoId;

  AuthStatus _status = AuthStatus.waiting;
  AuthStatus get status => _status;
  set status(AuthStatus val) {
    _status = val;
    notifyListeners();
  }

  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    notifyListeners();
  }

  StreamSubscription? _sub;
  StreamSubscription? get stream => _sub;

  // =============== //
  //      SignUp     //
  // =============== //

  Future<UserModel?> signup(String name, String tel) async {
    if (_kakaoId == null) return null;
    return await userRepository.createUser(name, tel, _kakaoId!);
  }

  // * ======================= * //
  // *                         * //
  // *        User Login       * //
  // *                         * //
  // * ======================= * //

  //** Oauth Login **//
  void oauthLogin() {
    LOG.log("Start to listen app link");
    _sub = linkStream.listen(
      (String? link) async {
        if (link != null) {
          LOG.log("App link received");

          ///** 앱 초기화 수행
          await _authorize(link);
          await _initialize();
          waiting = false;
          _sub?.cancel();
        } else {
          LOG.log("Auth status: failed");
          status = AuthStatus.failed;
          _sub?.cancel();
        }
      },
      onError: (error) {
        LOG.log("Auth status: failed. $error");
        status = AuthStatus.failed;
        _sub?.cancel();
      },
    );

    _kakaoLogin(); // 카카오 로그인
  }

  //** Test Login **//
  Future<void> testLogin() async {
    _user = UserModel(
      user_id: 29,
      user_name: "이소정",
      user_tel: "01071632489",
      user_kakao_id: "3164637603",
      user_hp: 10,
      user_cash: 100000,
      last_login: "2023-11-30 15:21:48.509743",
      login_cnt: 30,
      login_seq: 0,
    );

    RemoteDataSource.setAuthHeader("Bearer ${Secrets.JWT_TOKEN}");
    EventService.setUserId(29);

    await _initialize();
    waiting = false;
  }

  //** Local Login **//
  Future<void> localLogin() async {
    // 로컬스토리지에서 유저 정보 꺼내기
    var jsonUserInfo = await LocalStorage.readKey("user_info");

    if (jsonUserInfo == null) {
      LOG.log("Failed to login in local.");
      return;
    }

    // 유저 정보로 가져오기
    Map<String, dynamic> userInfo = json.decode(jsonUserInfo);
    LOG.log("Local login success! ${userInfo['user_name']}");
    _user = UserModel.fromJson(userInfo);

    // 토큰 세팅하기
    var token = await LocalStorage.readKey('jwt');
    RemoteDataSource.setAuthHeader("Bearer $token");
  }

  // 카카오 인증 시작
  Future<void> _kakaoLogin() async {
    await AuthCodeClient.instance
        .authorize(
      clientId: Secrets.KAKAO_REST_API_KEY,
      // TODO: Fix to REMOTE_SERVER_URL
      redirectUri: '${Secrets.TEST_SERVER_URL}/auth',
    )
        .onError((error, stackTrace) {
      status = AuthStatus.failed;
      return 'error';
    });
  }

  // 서비스 서버로부터 응답을 받아 인증 정보를 처리합니다.
  Future<void> _authorize(String link) async {
    Map<String, String> params = Uri.parse(link).queryParameters;
    String token = params['token']!;
    String kakaoId = params['kakao_id']!;

    // 회원가입이 필요한 경우
    if (token == 'access_denied') {
      _kakaoId = kakaoId;
      LOG.log("User need to signup");
      status = AuthStatus.permission;
    }

    // 토큰과 함꼐 서버로 유저 정보 요청
    RemoteDataSource.setAuthHeader("Bearer $token");
    Response response = await RemoteDataSource.get("/user");

    // 응답 파싱
    Map<String, dynamic> body = json.decode(response.body);
    if (response.statusCode != 200) {
      LOG.log("Server login failed ${body.toString()}");
      status = AuthStatus.failed;
    }

    // 토큰과 유저 정보 로컬스토리지에 저장 후
    await LocalStorage.saveKey("jwt", token);
    await LocalStorage.saveKey(
      "user_info",
      jsonEncode(body['result']),
    );

    String? userInfoStr = await LocalStorage.readKey('user_info');
    if (userInfoStr == null) {
      LOG.log("이런 예외는 생각지도 못했어요.. $userInfoStr");
      LocalStorage.clearKey();
      status = AuthStatus.failed;
      return;
    }

    // 상태로 가져오기
    _user = UserModel.fromJson(jsonDecode(userInfoStr));
    // 이벤트 서비스 초기화
    EventService.setUserId(_user!.user_id);

    status = AuthStatus.success;
    LOG.log("User authorization success: ${user!.user_id}");
  }

  // * ======================= * //
  // *                         * //
  // *     Initialize User     * //
  // *                         * //
  // * ======================= * //

  Future<void> _initialize() async {
    await _initializeTodos();
    await _initializeItems();

    status = AuthStatus.initialized;
  }

  // 유저 로그인이 완료된 경우 오늘자 투두 생성
  // 투두 정보 가져와서 세팅해주기
  Future<void> _initializeTodos() async {
    if (_user == null) {
      LOG.log("Can't initialize todo of unknown user.");
      return;
    }

    await RemoteDataSource.post("/todo/user/${_user!.user_id}").then(
      (response) {
        if (response.statusCode == 201) {
          var jsonBody = jsonDecode(response.body);
          LOG.log("Initialize todo: $jsonBody");
        } else {
          LOG.log("Error: ${response.body}");
          status = AuthStatus.failed;
        }
      },
    );

    await RemoteDataSource.get('/todo/today/count').then(
      (response) {
        if (response.statusCode == 200) {
          var jsonBody = jsonDecode(response.body);
          _todayCount = TodoTodayCount.fromJson(jsonBody['result']);
        } else {
          LOG.log("Error: ${response.body}");
          status = AuthStatus.failed;
        }
      },
    );
  }

  // 할일 및 펫 정보 가져와서 초기 세팅
  Future<void> _initializeItems() async {
    await RemoteDataSource.get("/item-inventory/${_user!.user_id}/pet")
        .then((response) {
      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);
        _mainPet = Item.fromJson(jsonBody['result']);
      } else {
        LOG.log("Error: ${response.body}");
        status = AuthStatus.failed;
      }
    });
  }
}
