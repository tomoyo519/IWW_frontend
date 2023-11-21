import 'package:flutter/material.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/viewmodel/landing.viewmodel.dart';
import 'package:provider/provider.dart';

// 의존성 주입을 위한 위젯 분리
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<LandingViewModel>(
      create: (context) => LandingViewModel(authService),
      child: Landing(),
    );
  }
}

/// 앱 초기 랜딩 페이지 화면
/// 디바이스에 카카오 토큰이 없거나 최초 설치한 유저
class Landing extends StatelessWidget {
  const Landing({super.key});

  // 카카오 로그인 버튼 클릭
  void handleKakaoLogin(BuildContext context) async {
    LandingViewModel viewModel = context.read<LandingViewModel>();

    // 로그인 수행
    bool isLoggedIn = await viewModel.login() != null;

    if (!isLoggedIn && context.mounted) {
      Navigator.pushReplacementNamed(context, "/signup");
    } else if (context.mounted) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => handleKakaoLogin(context),
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
                  ))
            ]),
      ),
    );
  }
}
