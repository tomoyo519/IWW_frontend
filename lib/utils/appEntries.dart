import "package:flutter/material.dart";
import "package:iww_frontend/utils/kakaoLogin.dart";
import "package:iww_frontend/view/screens/myroom.dart";

/// 메인에서 여러 가지 인증 로직을 테스트합니다.
class _SignUpTest {
  static final kakaoLogin = KaKaoLogin.instance;

  newUser() {
    kakaoLogin.disconnect();
  }

  expiredToken() {
    kakaoLogin.logout();
  }

  Future<bool> autoLogin() async {
    return await kakaoLogin.autoLogin() != null;
  }
}

// 유저 로그인 여부에 따른 앱 진입 시나리오
class AppEntries extends StatelessWidget {
  final _signInTest = _SignUpTest();
  AppEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                _signInTest.newUser();
                Navigator.pushNamed(context, "/landing");
              },
              child: const Text("🐤 회원가입")),
          ElevatedButton(
              onPressed: () {
                _signInTest.expiredToken();
                Navigator.pushNamed(context, "/landing");
              },
              child: const Text("🤔 액세스 토큰이 없거나 만료된 유저")),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/contact");
              },
              child: const Text("🤔 연락처 기반 친구추가")),
          ElevatedButton(
              onPressed: () async {
                _signInTest.autoLogin().then((result) {
                  if (result && context.mounted) {
                    Navigator.pushNamed(context, "/home");
                  }
                });
              },
              child: const Text("👀 메인 랜딩 페이지")),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
              onPressed: () {
                Navigator.pushNamed(context, '/myroom');
              },
              child: const Text("🚪 마이 룸")),
        ]);
  }
}
