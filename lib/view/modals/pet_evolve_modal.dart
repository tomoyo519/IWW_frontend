import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

// static method
Future<Object?> showPetEvolveModal(BuildContext context) {
  Item pet = context.read<UserInfo>().mainPet;

  return showCustomFullScreenModal(
    context: context,
    builder: (context) => EvolveLottie(
      pet: pet,
      // screen: screen,
    ),
  );
}

// Lottie 애니메이션을 재생하는 위젯
class EvolveLottie extends StatelessWidget {
  final Item pet;

  EvolveLottie({super.key, required this.pet});
  final assetsAudioPlayer = AssetsAudioPlayer();
  Future<void> playLottieAnimation(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3)).then((_) {
      Size screen = MediaQuery.of(context).size;

      showCustomFullScreenModal(
        context: context,
        builder: (context) => PetEvolveModal(
          pet: pet,
          screen: screen,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 위젯이 빌드될 때 애니메이션 재생 메소드 호출
    playLottieAnimation(context);
    assetsAudioPlayer.open(Audio("assets/evolve.mp3"));
    assetsAudioPlayer.play();
    return Center(
      child: Lottie.asset(
        'assets/todo/evolve.json',
        repeat: false,
      ),
    );
  }
}

class PetEvolveModal extends StatelessWidget {
  Item pet;
  Size screen;

  PetEvolveModal({
    super.key,
    required this.pet,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: screen.height * 0.6,
        maxWidth: screen.width * 0.8,
      ),
      child: Stack(children: [
        Lottie.asset(
          'assets/todo/confetti.json',
          width: double.infinity,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: Lottie.asset(
                      'assets/todo/topstar.json',
                      // width: screen.width * 0.5,
                    ),
                  ),
                  Text(
                    "진화 완료",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: screen.width * 0.7,
                child: Image.asset(
                  'assets/pets/${pet.path!.split('.')[0]}.gif',
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "펫이 진화했어요!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      pet.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'IBMPlexSans',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      pet.description ?? '언제나 행복한 여우는 블라블라',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  MyButton(
                      text: "닫기",
                      onpressed: (_) {
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      })
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
