import 'package:flutter/material.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignUpModal extends StatelessWidget {
  const SignUpModal({
    super.key,
    required this.screen,
  });

  final Size screen;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Lottie.asset(
            "assets/star.json",
            animate: true,
            width: screen.width * 0.5,
          ),
        ),
        Text(
          "👀 두윗이 처음이시네요!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Text(
          "펫과 함께하는 투두 여정을 시작할 준비가 되셨나요?",
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: MyButton(
            text: "회원가입",
            full: true,
            type: MyButtonType.primary,
            onpressed: (context) {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: MyButton(
            text: "취소하기",
            full: true,
            type: MyButtonType.shaded,
            onpressed: (context) {
              context.read<AuthService>().status = AuthStatus.failed;
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
