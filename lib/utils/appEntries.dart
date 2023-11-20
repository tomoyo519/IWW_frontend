import "dart:developer";

import "package:flutter/material.dart";
import "package:iww_frontend/repository/user.repository.dart";
import "package:iww_frontend/screens/user.model.dart";
import "package:iww_frontend/utils/kakaoLogin.dart";

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

  Future<bool> createUserData() async {
    final List<UserRequest> dummy = [
      UserRequest("Tom", "010-0000-0000", "1"),
      UserRequest("Tom2", "010-1111-1111", "2"),
      UserRequest("Tom3", "010-1213-2342", "3"),
      UserRequest("Tom4", "010-2342-2342", "4"),
      UserRequest("Tom5", "010-2343-0043", "5"),
      UserRequest("Tom6", "010-3455-4432", "6"),
      UserRequest("Tom7", "010-0003-0000", "7"),
      UserRequest("Tom8", "010-3111-1111", "8"),
      UserRequest("Tom9", "010-1413-2342", "9"),
      UserRequest("Tom10", "010-2342-5342", "10"),
      UserRequest("Tom11", "010-2383-0043", "11"),
      UserRequest("Tom12", "010-3155-4432", "12"),
      UserRequest("Tom13", "010-8888-0009", "13"),
      UserRequest("Tom14", "010-8899-0039", "14"),
      UserRequest("Tom15", "010-4502-0934", "15"),
      UserRequest("Tom16", "010-4534-9239", "16"),
      UserRequest("Tom17", "010-1111-1112", "17"),
      UserRequest("Tom18", "010-1111-1113", "18"),
      UserRequest("Tom19", "010-1111-1114", "19"),
      UserRequest("Tom20", "010-1111-1115", "20"),
      UserRequest("Tom21", "010-1111-1116", "21"),
      UserRequest("Tom22", "010-1111-1117", "22"),
      UserRequest("Tom23", "010-1111-1118", "23"),
      UserRequest("Tom24", "010-1111-1119", "24"),
      UserRequest("Tom25", "010-1111-1120", "25"),
      UserRequest("Tom26", "010-1111-1121", "26"),
      UserRequest("Tom27", "010-1111-1122", "27"),
      UserRequest("Tom28", "010-1111-1123", "28"),
      UserRequest("Tom29", "010-1111-1124", "29"),
      UserRequest("Tom30", "010-1111-1125", "30"),
      UserRequest("Tom31", "010-1111-1126", "31")
    ];

    try {
      for (var data in dummy) {
        await UserRepository.createTestUser(data);
      }
      return true;
    } catch (error) {
      log("Error creating test users: $error");
      return false;
    }
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
                // _signInTest.createUserData().then((value) {
                //   if (value == true) {
                Navigator.pushNamed(context, "/contact");
                //   }
                // });
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
              child: const Text("👀 메인 랜딩 페이지"))
        ]);
  }
}
