import 'package:flutter/material.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:lottie/lottie.dart';

// static method
void showLoginAchieveModal(BuildContext context, String message) {
  showCustomFullScreenModal(
    context,
    LoginAchieveModal(message: message),
  );
}

class LoginAchieveModal extends StatelessWidget {
  final String message;
  const LoginAchieveModal({
    super.key,
    required this.message,
  });

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
            message,
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
