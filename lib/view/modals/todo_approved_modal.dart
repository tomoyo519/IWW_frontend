import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/custom_pet_modal.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void showTodoApprovedModal(BuildContext context, {required String message}) {
  Size screen = MediaQuery.of(context).size;
  Item pet = context.read<UserInfo>().mainPet;

  showCustomFullScreenModal(
    context: context,
    builder: (context) => TodoApprovedModal(
      pet: pet,
      screen: screen,
      approveMessege: message,
    ),
  );
}

//
class TodoApprovedModal extends StatelessWidget {
  final Item pet;
  final Size screen;
  String approveMessege;

  TodoApprovedModal({
    super.key,
    required this.pet,
    required this.screen,
    required this.approveMessege,
  });

  @override
  Widget build(BuildContext context) {
    return MyPetModal(
      pet: pet,
      screen: screen,
      title: "그룹 할일 인증 완료!",
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(approveMessege),
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
                  children: const [
                    _StateBadge(
                      title: "10",
                      desc: "경험치 상승",
                      icon: Icon(
                        Icons.keyboard_double_arrow_up_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    _StateBadge(
                      title: "25",
                      desc: "캐시 보상",
                      icon: Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.orange,
                        size: 18,
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
                  full: true,
                  text: "닫기",
                  type: MyButtonType.secondary,
                  onpressed: (_) async {
                    Navigator.pop(context);
                    final assetsAudioPlayer = AssetsAudioPlayer();
                    assetsAudioPlayer.open(Audio("assets/main.mp3"));
                    assetsAudioPlayer.play();
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: MyButton(
                  text: "상점 바로가기",
                  onpressed: (_) async {
                    final assetsAudioPlayer = AssetsAudioPlayer();
                    assetsAudioPlayer.open(Audio("assets/main.mp3"));
                    assetsAudioPlayer.play();
                    Navigator.pop(context);
                    context.read<AppNavigator>().navigate(AppRoute.shop);
                  },
                ),
              )
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
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w900,
              color: Color(0xfff08636),
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
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
