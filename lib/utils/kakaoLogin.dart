import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';

/// 카카오 서버와의 통신과 인증 토큰 발급을 담당하는 서비스 레이어
class KaKaoLogin {
  // 카카오톡 로그인 후 사용자 정보 반환
  Future<User?> login() async {
    // Flutter SDK에 저장된 토큰의 유효성을 먼저 검사하고
    if (await getTokenInfo() != null) {
      return getUserInfo();
    }
    // 유효하지 않으면 로그인 시도
    return await _doLogin().then((result) => result ? getUserInfo() : null);
  }

  // 카카오톡 로그아웃
  Future<bool> logout() async {
    try {
      await UserApi.instance.logout();
      log('로그아웃 성공, SDK에서 토큰 삭제');
      return true;
    } catch (error) {
      log('로그아웃 실패, SDK에서 토큰 삭제 $error');
      return false;
    }
  }

  // 카카오톡 연결 해제
  Future<bool> disconnect() async {
    try {
      await UserApi.instance.unlink();
      log('연결 끊기 성공, SDK에서 토큰 삭제');
      return true;
    } catch (error) {
      log('연결 끊기 실패 $error');
      return false;
    }
  }

  // 사용자 정보 반환
  Future<User?> getUserInfo() async {
    try {
      return await UserApi.instance.me();
    } catch (error) {
      log('사용자 정보 요청 실패 $error');
      return null;
    }
  }

  // Flutter SDK에 저장된 액세스 토큰 정보 조회
  Future<AccessTokenInfo?> getTokenInfo() async {
    try {
      return await UserApi.instance.accessTokenInfo();
    } catch (error) {
      return null;
    }
  }

  // 사용자에게 카카오톡 인증을 요청하고
  // 인증 토큰을 내부적으로 저장
  Future<bool> _doLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        log('Kakao Talk login success');
        return true;
      } catch (error) {
        log('Kakao Talk login failed: $error');
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return false;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          log('Kakao Account login success');
          return true;
        } catch (error) {
          log('Kakao Account login failed: $error');
          return false;
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        log('Kakao Account login success');
        return true;
      } catch (error) {
        log('Kakao Account login failed: $error');
        return false;
      }
    }
  }
}
