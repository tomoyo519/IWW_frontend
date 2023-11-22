import "dart:developer";

import "package:flutter/material.dart";
import 'package:iww_frontend/service/auth.service.dart';
import "package:provider/provider.dart";

/// 메인에서 여러 가지 인증 로직을 테스트합니다.
class _SignUpTest {
  Future<void> newUser(BuildContext context) async {
    final authService = context.read<AuthService>();
    // 로컬에 저장된 유저정보 가져옴
    await authService.disconnect();
    log("[TEST] User first installed the app.");
  }

  Future<void> expiredToken(BuildContext context) async {
    final authService = context.read<AuthService>();
    await authService.logout();
    log("[TEST] User logged out.");
  }

  Future<bool> autoLogin(BuildContext context) async {
    final authService = context.read<AuthService>();
    return await authService.login() != null;
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
                _signInTest.newUser(context);
                Navigator.pushNamed(context, "/landing");
              },
              child: const Text("🐤 회원가입")),
          ElevatedButton(
              onPressed: () {
                _signInTest.expiredToken(context);
                Navigator.pushNamed(context, "/landing");
              },
              child: const Text("🤔 로그아웃된 유저")),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/contact");
              },
              child: const Text("🤔 연락처 기반 친구추가")),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
                // _signInTest.autoLogin(context).then((result) {
                //   if (result && context.mounted) {
                //   }
                // });
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
