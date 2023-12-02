import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
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
  set user(UserModel? val) {
    _user = val;
    notifyListeners();
  }

  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    notifyListeners();
  }

  String? _kakaoId;
  String? get kakaoId => _kakaoId;

  AuthStatus _status = AuthStatus.waiting;
  AuthStatus get status => _status;
  set status(AuthStatus val) {
    _status = val;
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

  // =============== //
  //      Login      //
  // =============== //

  void oauthLogin() {
    LOG.log("Start to listen app link");
    _sub = linkStream.listen(
      (String? link) async {
        if (link != null) {
          LOG.log("App link received");

          ///** 앱 초기화 수행
          /// 1. 로그인 인증
          /// 2. 할일 초기화
          /// */
          await _authorize(link);
          await _initializeTodo();
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

    _kakaoLogin();
  }

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
    user = UserModel.fromJson(userInfo);

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

  // 유저 로그인이 완료된 경우 오늘자 투두 생성
  // 투두 정보 가져와서 세팅해주기
  Future<void> _initializeTodo() async {
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
        }
      },
    );

    await RemoteDataSource.get('/todo/today/count').then(
      (response) {
        if (response.statusCode == 200) {
          var jsonBody = jsonDecode(response.body);
          LOG.log("Today's todo count: $jsonBody");
        } else {
          LOG.log("Error: ${response.body}");
        }
      },
    );
  }

  // 할일 및 펫 정보 가져와서 초기 세팅
  Future<void> _initializeItems() async {
    await RemoteDataSource.get("/item");
  }

  /// 서비스 서버로부터 응답을 받아 인증 정보를 처리합니다.
  /// [@var		object	async]
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
    user = UserModel.fromJson(jsonDecode(userInfoStr));
    status = AuthStatus.success;
    LOG.log("User authorization success: ${user!.user_id}");
  }
}
