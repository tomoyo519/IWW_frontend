import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/mypage/reward.model.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "업적 달성!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: SizedBox(
              width: screen.width * 0.5,
              // height: 50,
              child: Stack(children: [
                Image.asset(
                  reward.achiImg!,
                  errorBuilder: (context, _, __) =>
                      Lottie.asset('assets/star.json'),
                ),
                Lottie.asset('assets/todo/confetti.json'),
              ]),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                text: "닫기",
                type: MyButtonType.secondary,
                onpressed: (context) => Navigator.pop(context),
              ),
              SizedBox(
                width: 10,
              ),
              MyButton(
                text: "마이페이지",
                onpressed: (context) {
                  Navigator.pop(context);
                  context.read<AppNavigator>().navigate(AppRoute.mypage);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
