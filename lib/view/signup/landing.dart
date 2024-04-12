import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/modals/signup_modal.dart';
import 'package:iww_frontend/view/signup/signup.dart';
import 'package:provider/provider.dart';

/// 앱 초기 랜딩 페이지 화면
/// 디바이스에 카카오 토큰이 없거나 최초 설치한 유저
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService service = context.watch<AuthService>();

    if (service.status == AuthStatus.permission) {
      return SignUpPage();
    }

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("두윗"),
            const Text("펫과 함께하는 소셜 투두리스트"),
            ElevatedButton(
              // 로그인 수행
              onPressed: () => service.oauthLogin(prompt: true),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                backgroundColor: const Color(0xfffee500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/kakao.png",
                    width: 30,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "카카오 로그인",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SignUpModal();
                  },
                );
              },
              child: Text("일반 로그인"),
            ),
          ],
        ),
      ),
    );
  }
}
