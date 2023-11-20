import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// OAuth 로그인 유틸 클래스
class KaKaoLogin {
  // 싱글톤 객체
  KaKaoLogin._internal();
  static final _instance = KaKaoLogin._internal();
  static KaKaoLogin get instance => _instance;

  // 카카오 로그인
  Future<User?> login() async {
    // 액세스 토큰 저장
    final SharedPreferences pref = await SharedPreferences.getInstance();

    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        // 로그인하고 토큰을 저장한 후 사용자 정보를 가져옵니다.
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        _saveAccessToken(true, token, pref);
        return await _getUserInfo().then((info) {
          String? kakaoId = info?.id.toString();
          String? profilePic = info?.kakaoAccount?.profile?.profileImageUrl;
          _saveUserKakaoProfile(kakaoId, profilePic, pref);
          return info;
        });
      } catch (error) {
        _onLoginFail(true, error);

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        return await _loginWithKakaoAccount(pref);
      }
    } else {
      // 카카오톡 실행이 불가능한 경우
      return await _loginWithKakaoAccount(pref);
    }
  }

  // 카카오 로그아웃
  Future<bool> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      await _removeLoginInfos(pref);
      await UserApi.instance.logout();
      log('로그아웃 성공, SDK에서 토큰 삭제');
      return true;
    } catch (error) {
      log('로그아웃 실패, SDK에서 토큰 삭제 $error');
      return false;
    }
  }

  // 디바이스에 저장된 토큰이 있는지 확인하고
  // 없거나 만료된 경우 새로운 로그인을 시도합니다
  Future<String?> autoLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final now = DateTime.now();

    String? accessToken = pref.getString("access_token");
    int? refreshExpire = pref.getInt("refresh_expire");
    int? tokenExpire = pref.getInt("token_expire");

    // 만약 토큰이 없으면 로그인
    if (accessToken == null) {
      return await login().then((user) => user?.id.toString());
    }

    // 만료가 지났는지 확인
    DateTime? expire;
    if (refreshExpire != null) {
      expire = DateTime.fromMillisecondsSinceEpoch(refreshExpire);
    } else if (tokenExpire != null) {
      expire = DateTime.fromMicrosecondsSinceEpoch(tokenExpire);
    } else {
      // 만료기간이 이상하면 로그인
      return await login().then((user) => user?.id.toString());
    }

    if (expire.isBefore(now)) {
      return await login().then((user) => user?.id.toString());
    }

    // 있으면 로컬에서 읽어오기
    String? kakaoId = pref.getString("user_kakao_id");
    log("User auto login: $kakaoId");
    return kakaoId;
  }

  // 카카오계정과 연결 끊기
  void disconnect() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      await _removeLoginInfos(pref);
      await UserApi.instance.unlink();
      log('연결 끊기 성공, SDK에서 토큰 삭제');
    } catch (error) {
      log('연결 끊기 실패 $error');
    }
  }

  // 인증 토큰으로 유저 정보를 반환
  Future<User?> _getUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      return user;
    } catch (error) {
      log('Failed to get user information from Kakao OAuth: $error');
      return null;
    }
  }

  // 로그인 성공 시 처리
  void _saveAccessToken(
      bool isTalk, OAuthToken token, SharedPreferences pref) async {
    log('카카오${isTalk ? "톡" : "계정"}으로 로그인 성공');

    // 로컬에 토큰 저장
    String accessToken = token.accessToken;
    int tokenExpire = token.expiresAt.millisecondsSinceEpoch;
    int? refreshExpire = token.refreshTokenExpiresAt?.millisecondsSinceEpoch;

    await pref.setString("access_token", accessToken);
    await pref.setInt("token_expire", tokenExpire);
    await pref.setInt("refresh_expire", refreshExpire ?? 0);
    log("Saved in SharedPreferences, refresh expires at: ${token.refreshTokenExpiresAt}");
  }

  // 로컬에 카카오 프로필 저장
  void _saveUserKakaoProfile(
      String? kakao_id, String? imgUrl, SharedPreferences pref) async {
    // 카카오 아이디
    if (kakao_id != null && kakao_id.isNotEmpty) {
      await pref.setString("user_kakao_id", kakao_id);
    }

    // 카카오 프로필 이미지
    var imgPath;
    if (imgUrl != null && imgUrl.isNotEmpty) {
      imgPath = await LocalStorage.save(imgUrl, '$kakao_id.jpg');
    }

    log("Saved in SharedPreferences: {user_kakao_id: $kakao_id, profile: $imgPath}");
  }

  // 로그인 실패 시 로직
  void _onLoginFail(bool isTalk, Object error) {
    log("카카오${isTalk ? "톡" : "계정"}으로 로그인 실패 $error");
  }

  // 카카오계정으로 로그인
  Future<User?> _loginWithKakaoAccount(SharedPreferences pref) async {
    try {
      // 로그인하고 토큰을 저장한 후 사용자 정보를 가져옵니다.
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      _saveAccessToken(true, token, pref);
      return await _getUserInfo().then((info) {
        String? kakaoId = info?.id.toString();
        String? profilePic = info?.kakaoAccount?.profile?.profileImageUrl;
        _saveUserKakaoProfile(kakaoId, profilePic, pref);
        return info;
      });
    } catch (error) {
      _onLoginFail(false, error);
      return null;
    }
  }

  // 로그아웃 성공 시 처리
  Future<bool> _removeLoginInfos(SharedPreferences pref) async {
    try {
      await pref.remove("user_kakao_id");
      await pref.remove("access_token");
      await pref.remove("token_expire");
      await pref.remove("refresh_expire");
      await LocalStorage.delete("profile.jpg");
      log('Remove local user info: ${pref.getString("user_kakao_id") == null}');
      return true;
    } catch (error) {
      log('Error removing user info: $error');
      return false;
    }
  }
}
