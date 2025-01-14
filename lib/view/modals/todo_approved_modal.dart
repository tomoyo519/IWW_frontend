import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/custom_pet_modal.dart';
import 'package:lottie/lottie.dart';

Future<Object?> showTodoApprovedModal(BuildContext context,
    {required String message}) {
  Size screen = MediaQuery.of(context).size;

  Map<String, dynamic> data = jsonDecode(message);
  String itemPath = data['item_path'];
  String approveMessege = data['message']!;

  return showCustomFullScreenModal(
    context: context,
    builder: (context) => TodoApprovedModal(
      itemPath: itemPath,
      screen: screen,
      approveMessege: approveMessege,
    ),
  );
}

extension DoubleExt on double {
  double x(double mul) => this * mul;
}

//
class TodoApprovedModal extends StatelessWidget {
  final String itemPath;
  final Size screen;
  String approveMessege;
  final assetsAudioPlayer = AssetsAudioPlayer();
  TodoApprovedModal({
    super.key,
    required this.itemPath,
    required this.screen,
    required this.approveMessege,
  });

  @override
  Widget build(BuildContext context) {
    assetsAudioPlayer.open(Audio("assets/coin.mp3"));
    assetsAudioPlayer.play();
    double fs = MediaQuery.of(context).size.width * 0.01;

    return MyPetModal(
      itemPath: itemPath,
      screen: screen,
      title: "그룹 할일 확인 완료!",
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              approveMessege,
              style: TextStyle(
                fontSize: 3.5 * fs,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    _StateBadge(
                      title: "10",
                      desc: "경험치 상승",
                      icon: Icon(
                        Icons.keyboard_double_arrow_up_rounded,
                        color: AppTheme.secondary,
                        size: 6 * fs,
                      ),
                    ),
                    _StateBadge(
                      title: "25",
                      desc: "캐시 보상",
                      icon: Icon(
                        Icons.monetization_on_outlined,
                        color: AppTheme.primary,
                        size: 6 * fs,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: MyButton(
                  text: "닫기",
                  type: MyButtonType.shaded,
                  onpressed: (_) async {
                    Navigator.pop(context);
                    final assetsAudioPlayer = AssetsAudioPlayer();
                    assetsAudioPlayer.open(Audio("assets/main.mp3"));
                    assetsAudioPlayer.play();
                  },
                ),
              ),
            ],
          )
        ],
      ),
      backgroud: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Lottie.asset('assets/todo/levelup.json'),
      ),
    );
  }
}

class _StateBadge extends StatelessWidget {
  final String title;
  final String desc;
  final Icon icon;

  const _StateBadge({
    required this.title,
    required this.desc,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double fs = MediaQuery.of(context).size.width * 0.01;
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 7 * fs,
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w900,
              color: AppTheme.tertiary,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: icon,
                ),
                Text(
                  desc,
                  style: TextStyle(fontSize: 4 * fs),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
