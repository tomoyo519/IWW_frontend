import 'package:flutter/material.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:provider/provider.dart';
import '../home/home.dart';

/// 앱 초기 랜딩 페이지 화면
/// 디바이스에 카카오 토큰이 없거나 최초 설치한 유저
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // 카카오 로그인 버튼 클릭
  void _kakaoLogin(BuildContext context, AuthService authService) async {
    // 로그인 수행
    authService.login(background: false);

    switch (authService.status) {
      //  로그인 완료된 경우
      case AuthStatus.success:
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      // 회원가입이 필요한 경우
      case AuthStatus.permission:
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, "/signup");
        }
      default:
      // 로그인 취소된 경우
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

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
              // onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
              onPressed: () => _kakaoLogin(context, authService),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  backgroundColor: const Color(0xfffee500),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
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
            )
          ],
        ),
      ),
    );
  }
}
