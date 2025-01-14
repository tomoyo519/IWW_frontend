import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/model/mypage/reward.model.dart';
import 'package:iww_frontend/model/user/attendance.model.dart';
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

  Item? _mainPet;
  Item? get mainPet => _mainPet;
  set mainPet(Item? val) {
    _mainPet = val;
  }

  Rewards? _reward;
  Rewards? get reward => _reward;

  String? _kakaoId;
  String? get kakaoId => _kakaoId;

  List<UserAttandance>? _attendance;
  List<UserAttandance>? get attendance => _attendance;

  Map<String, dynamic>? _tier;
  Map<String, dynamic>? get tier => _tier;

  AuthStatus _status = AuthStatus.waiting;
  AuthStatus get status => _status;
  set status(AuthStatus val) {
    _status = val;
    // 로그인 로그
    if (val == AuthStatus.initialized) {
      String now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      LOG.log('[$now] ${_user!.user_id} logged in.');
      notifyListeners();
    }
  }

  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    notifyListeners();
  }

  StreamSubscription? _sub;
  StreamSubscription? get stream => _sub;

  // * ======================= * //
  // *                         * //
  // *       User Singup       * //
  // *                         * //
  // * ======================= * //

  Future<void> signup(String name, String tel, String petName) async {
    waiting = true;

    GetUserResult? result =
        await userRepository.createUser(name, tel, _kakaoId!, petName);

    if (result == null) {
      LOG.log("Failed to signup.");
      status = AuthStatus.failed;
      waiting = false;
      return;
    }

    // 상태 저장
    _user = result.user;
    _mainPet = result.pet;
    _reward = result.reward;

    status = AuthStatus.initialized;
    waiting = false;
  }

  Future<bool?> isNameUnique(String name) async {
    return await userRepository.isUserNameUnique(name);
  }

  // * ======================= * //
  // *                         * //
  // *        User Login       * //
  // *                         * //
  // * ======================= * //

  ///** 카카오 인증 기반 로그인을 시작합니다.
  /// signup: false이면 access_denied를 failed 상태로 처리 [default true]
  /// prompt: true이면 로그인 여부에 관계없이 로그인 페이지로 이동
  /// */
  void oauthLogin({bool? prompt, bool? signup}) {
    LOG.log("Start to listen app link");
    _sub = linkStream.listen(
      (String? link) async {
        if (link != null) {
          LOG.log("App link received");

          // 앱 초기화 수행
          await _authorize(link, signup: signup);
          if (status == AuthStatus.success) {
            await _initialize();
          }
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

    _kakaoLogin(prompt: prompt); // 카카오 로그인
  }

  // * 로컬에 저장된 토큰 기반 로그인을 시작합니다. * //
  Future<void> localLogin() async {
    waiting = true;

    // 로컬에 저장된 토큰 확인
    var token = await LocalStorage.readKey('jwt');
    if (token == null) {
      status = AuthStatus.failed;
      waiting = false;
      return;
    }

    RemoteDataSource.setAuthHeader("Bearer $token");

    var response = await RemoteDataSource.get('/user');
    if (response.statusCode == 200) {
      // 유저 정보 초기화
      var jsonBody = jsonDecode(response.body);

      _user = UserModel.fromJson(jsonBody['result']['user']);
      _mainPet = Item.fromJson(jsonBody['result']['user_pet']);

      // 로그인 업적이 있는 경우
      if (jsonBody['result']['user_achi'] != null) {
        _reward = Rewards.fromJson(jsonBody['result']['user_achi']);
      }

      await _initialize();
      status = AuthStatus.initialized;
    } else {
      // Unauthorized
      status = AuthStatus.failed;
    }
    waiting = false;
  }

  ///** 카카오 인증을 시작합니다.
  /// prompt: true이면 기존 로그인 여부에 관계없이
  /// 로그인 페이지로 이동합니다.
  /// */
  Future<void> _kakaoLogin({bool? prompt}) async {
    List<Prompt> prompts = prompt == true ? [Prompt.login] : [];
    try {
      await AuthCodeClient.instance.authorize(
        clientId: Secrets.KAKAO_REST_API_KEY,
        prompts: prompts,
        redirectUri: '${Secrets.REMOTE_SERVER_URL}/auth',
      );
    } catch (error) {
      LOG.log('Auth error $error');
      status = AuthStatus.failed;
      return;
    }
  }

  // 서비스 서버로부터 응답을 받아 인증 정보를 처리합니다.
  Future<void> _authorize(String link, {bool? signup}) async {
    Map<String, String> params = Uri.parse(link).queryParameters;
    String token = params['token']!;
    String kakaoId = params['kakao_id']!;

    bool signupOption = signup ?? true;

    // 회원가입이 필요한 경우
    if (token == 'access_denied') {
      _kakaoId = kakaoId;
      LOG.log("User need to signup");

      // signup 옵션이 켜진 경우는 회원가입 화면으로 이동
      status = signupOption == true ? AuthStatus.permission : AuthStatus.failed;
      return;
    }

    // 토큰과 함께 서버로 유저 정보 요청
    RemoteDataSource.setAuthHeader("Bearer $token");
    Response response = await RemoteDataSource.get("/user");

    // 응답 파싱
    Map<String, dynamic> body = json.decode(response.body);
    if (response.statusCode != 200) {
      LOG.log("Server login failed ${body.toString()}");
      status = AuthStatus.failed;
    }

    // 토큰 로컬스토리지에 저장 후
    await LocalStorage.saveKey("jwt", token);

    _user = UserModel.fromJson(body['result']['user']);
    _mainPet = Item.fromJson(body['result']['user_pet']);

    status = AuthStatus.success;
    LOG.log("User authorization success: ${user!.user_id}");
  }

  // * ======================= * //
  // *                         * //
  // *       User Logout       * //
  // *                         * //
  // * ======================= * //

  Future<void> logout() async {
    await LocalStorage.clearKey();
    String? token = await LocalStorage.readKey('jwt');

    LOG.log('[User Logout] token $token');
    status = AuthStatus.failed;
    waiting = false;
  }

  // * ======================= * //
  // *                         * //
  // *     Initialize User     * //
  // *                         * //
  // * ======================= * //

  Future<void> _initialize() async {
    _reward = await userRepository.initializeTodos(_user!.user_id);
    _attendance = await userRepository.fetUserAtt(_user!.user_id);
    _tier = await userRepository.fetchUserTier(user!.user_id);
    status = AuthStatus.initialized;
  }
}
