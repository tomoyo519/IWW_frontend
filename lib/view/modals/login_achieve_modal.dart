import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/mypage/reward.model.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

// static method
Future<Object?> showLoginAchieveModal(BuildContext context, String message) {
  return showCustomFullScreenModal(
    context: context,
    builder: (context) => LoginAchieveModal(message: message),
  );
}

class LoginAchieveModal extends StatelessWidget {
  final String message;
  final assetsAudioPlayer = AssetsAudioPlayer();
  LoginAchieveModal({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    assetsAudioPlayer.open(Audio("assets/happy.mp3"));
    assetsAudioPlayer.play();
    var jsonMessage = jsonDecode(message);
    Rewards reward = Rewards.fromJson(jsonMessage);

    Size screen = MediaQuery.of(context).size;
    double fs = screen.width * 0.01;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "업적 달성!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 6 * fs,
              fontWeight: FontWeight.w900,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: SizedBox(
              width: screen.width * 0.5,
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
          Padding(
            padding: EdgeInsets.only(bottom: 3 * fs),
            child: Text(
              reward.achiName,
              style: TextStyle(
                  fontSize: 4.5 * fs,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10 * fs),
            child: Text(
              reward.achiDesc!,
              style: TextStyle(
                fontSize: 3 * fs,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyButton(
                text: "닫기",
                onpressed: (context) async {
                  Navigator.pop(context, true);

                  final assetsAudioPlayer = AssetsAudioPlayer();

                  assetsAudioPlayer.open(
                    Audio("assets/main.mp3"),
                  );

                  assetsAudioPlayer.play();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
