import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/mypage/reward.model.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:lottie/lottie.dart';

// static method
void showLoginAchieveModal(BuildContext context, String message) {
  showCustomFullScreenModal(
    context: context,
    builder: (context) => LoginAchieveModal(message: message),
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
    var jsonMessage = jsonDecode(message);
    Rewards reward = Rewards.fromJson(jsonMessage);

    Size screen = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screen.width * 0.5,
            // height: 50,
            child: Image.asset(
              reward.achiImg!,
              errorBuilder: (context, _, __) =>
                  Lottie.asset('assets/star.json'),
            ),
          ),
          Text(
            reward.achiName,
            style: TextStyle(
                color: Colors.orange,
                fontSize: 19,
                fontWeight: FontWeight.bold),
          ),
          Text(reward.achiDesc!),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("닫기"),
          )
        ],
      ),
    );
  }
}
