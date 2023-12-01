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
  Future<void> login() async {
    // 카카오 인증 시작

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

  // =============== //
  //   Local Login   //
  // =============== //

  Future<void> localLogin() async {
    // 로컬스토리지에서 유저 정보 꺼내기
    var jsonUserInfo = await LocalStorage.readKey("user_info");

    if (jsonUserInfo == null) {
      LOG.log("Failed to login in local.");
      return _navigate("/landing");
    }

    // 유저 정보로 가져오기
    Map<String, dynamic> userInfo = json.decode(jsonUserInfo);
    LOG.log("Local login success! ${userInfo['user_name']}");
    user = UserModel.fromJson(userInfo);
    return _navigate("/todo");
  }

  // =============== //
  //     Helpers     //
  // =============== //

  // 서비스 서버로부터 JWT 토큰 수신
  StreamSubscription? listenRedirect() {
    LOG.log("Start to listen app link");
    return linkStream.listen((String? link) async {
      if (link != null) {
        LOG.log("App link received");
        await _handleResponse(link);
      } else {
        LOG.log("Auth status: failed");
        status = AuthStatus.failed;
        return _navigate("/landing");
        // return;
      }
    }, onError: (error) {
      LOG.log("Auth status: failed. $error");
      status = AuthStatus.failed;
      return _navigate("/landing");
    });
  }

  Future<void> _handleResponse(String link) async {
    Map<String, String> params = Uri.parse(link).queryParameters;
    String token = params['token']!;
    String kakaoId = params['kakao_id']!;

    // 회원가입이 필요한 경우
    if (token == 'access_denied') {
      _kakaoId = kakaoId;
      LOG.log("User need to signup");
      status = AuthStatus.permission;
      return _navigate("/signup");
    }

    // 토큰과 함꼐 서버로 유저 정보 요청
    RemoteDataSource.setAuthHeader("Bearer $token");
    LOG.log("Auth: ${RemoteDataSource.baseHeaders['Authorization'] ?? 'wtf'}");
    Response response = await RemoteDataSource.get("/user");

    // 응답 파싱
    Map<String, dynamic> body = json.decode(response.body);
    if (response.statusCode != 200) {
      LOG.log("Server login failed ${body.toString()}");
      status = AuthStatus.failed;
      return _navigate("/landing");
    }

    // 토큰과 유저 정보 로컬스토리지에 저장 후
    await LocalStorage.saveKey("jwt", token);
    LOG.log("User Logged in! ${body['result']}");
    await LocalStorage.saveKey(
      "user_info",
      jsonEncode(body['result']),
    );

    String? userInfoStr = await LocalStorage.readKey('user_info');
    if (userInfoStr == null) {
      LOG.log("이런 예외는 생각지도 못했어요.. $userInfoStr");
      LocalStorage.clearKey();
      status = AuthStatus.failed;
      return _navigate('/landing');
    }

    // 상태로 가져오기
    user = UserModel.fromJson(jsonDecode(userInfoStr));
    status = AuthStatus.success;
    LOG.log("User Logged in!");
  }

  // 내비게이션
  Future<void> _navigate(String path, {Object? arguments}) async {
    GlobalNavigator.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      path,
      (route) => false,
      arguments: arguments,
    );
    waiting = false;
  }
}
