import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/custom_pet_modal.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

Future<Object?> showTodoDoneModal(BuildContext context) {
  Size screen = MediaQuery.of(context).size;
  Item pet = context.read<UserInfo>().mainPet;
  final assetsAudioPlayer = AssetsAudioPlayer();
  assetsAudioPlayer.open(Audio("assets/coin.mp3"));
  assetsAudioPlayer.play();
  Widget background = SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Lottie.asset(
      'assets/todo/confetti.json',
    ),
  );

// TODO - 투두 완료 소리 넣기.
  return showCustomFullScreenModal(
    context: context,
    builder: (context) => MyPetModal(
      itemPath: pet.path!,
      screen: screen,
      title: '오늘의 첫 할일 달성!',
      backgroud: background,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("남은 할일도 모두 달성해보자👊"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Lottie.asset(
                    'assets/todo/coin.json',
                    width: 40,
                    height: 40,
                  ),
                ),
                Text(
                  "+100",
                  style: TextStyle(
                    color: Color(0xfff08636),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
          MyButton(
            // full: true,
            onpressed: (_) => Navigator.pop(context, true),
            text: "닫기",
          ),
        ],
      ),
    ),
  );
}
