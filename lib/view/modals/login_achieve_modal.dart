import 'package:flutter/material.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:lottie/lottie.dart';

// static method
Future<void> showLoginAchieveModal(BuildContext context) {
  return showCustomFullScreenModal(
    context,
    LoginAchieveModal(),
  );
}

class LoginAchieveModal extends StatelessWidget {
  const LoginAchieveModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Lottie.asset("assets/star.json", animate: true),
          ),
          Text(
            "로그인 100회 달성!",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 19,
                fontWeight: FontWeight.bold),
          ),
          Text("꾸준한 당신을 응원해요!"),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("닫기"),
          )
        ],
      ),
    );
  }
}
