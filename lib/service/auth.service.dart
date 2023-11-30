import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
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
  UserInfo? _user;
  UserInfo? get user => _user;
  set user(UserInfo? val) {
    _user = val;
    notifyListeners();
  }

  bool _waiting = true;
  bool get waiting => _waiting;
  set waiting(bool val) {
    _waiting = val;
    notifyListeners();
  }

  AuthStatus _status = AuthStatus.waiting;
  AuthStatus get status => _status;
  set status(AuthStatus val) {
    _status = val;
    notifyListeners();
  }

  StreamSubscription? _sub;

  // =============== //
  //      Login      //
  // =============== //
  Future<void> login() async {
    // 카카오 인증 시작
    AuthCodeClient.instance.authorize(
      clientId: Secrets.KAKAO_REST_API_KEY,
      redirectUri: '${Secrets.TEST_SERVER_URL}/auth',
    );

    // 서비스 서버가 보내는 JWT 토큰 수신
    _sub = await _onRedirected();

    _sub?.cancel();
    // AuthStatus status = await _onRedirected();

    // 회원가입이 필요한 경우
    if (status == AuthStatus.permission) {
      LOG.log("User need to signup");
      return _navigate("/signup");
    }

    // 인증에 실패한 경우
    if (status == AuthStatus.failed) {
      LOG.log("Auth status: failed");
      return _navigate("/landing");
    }

    String? token = await LocalStorage.readKey("jwt");
    if (token == null) {
      return _navigate("/landing");
    }

    // 토큰과 함꼐 서버로 로그인 요청
    Response response = await RemoteDataSource.get(
      "/auth/login",
      headers: {"Authorization": "Bearer $token"},
    );

    // 응답 파싱
    Map<String, dynamic> body = json.decode(response.body);
    if (response.statusCode != 200) {
      LOG.log("Server login failed ${body.toString()}");
      return _navigate("/landing");
    }

    // 로컬스토리지에 저장 후
    await LocalStorage.saveKey("user_info", jsonEncode(body['result']));

    // 유저 정보로 가져오기
    user = UserInfo.fromJson(body['result']);
    return _navigate("/todo");
  }

  // =============== //
  //      Login      //
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
    user = UserInfo.fromJson(userInfo);
    return _navigate("/todo");
  }

  // =============== //
  //     Helpers     //
  // =============== //

  // 서비스 서버로부터 JWT 토큰 수신
  Future<StreamSubscription> _onRedirected() async {
    return linkStream.listen((String? link) async {
      LOG.log("listen stream...");
      if (link != null) {
        await _handleResponse(link);
      } else {
        status = AuthStatus.failed;
        return;
      }
    }, onError: (error) {
      LOG.log("Error: $error");
      status = AuthStatus.failed;
      return;
    });

    // try {
    //   final link = await getInitialLink();
    //   if (link != null) {
    //     // throw Exception("No redirected link.");

    //   } else

    // } catch (error) {
    //   LOG.log("Error while handling $error");
    //   return AuthStatus.failed;
    // }
  }

  Future<void> _handleResponse(String link) async {
    Map<String, String> params = Uri.parse(link).queryParameters;
    String token = params['token']!;
    String kakaoId = params['kakao_id']!;

    if (token == 'access_denied') {
      kakaoId = kakaoId;
      status = AuthStatus.permission;
      return;
    }

    await LocalStorage.saveKey("jwt", token);
    status = AuthStatus.success;
    return;
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
