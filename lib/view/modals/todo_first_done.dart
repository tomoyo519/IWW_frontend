import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void showTodoDoneModal(BuildContext context) {
  Size screen = MediaQuery.of(context).size;
  Item pet = context.read<UserInfo>().mainPet;

  Widget background = SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Lottie.asset(
      'assets/todo/confetti.json',
    ),
  );

  showCustomFullScreenModal(
    context: context,
    builder: (context) => MyPetModal(
      pet: pet,
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
            onpressed: (_) => Navigator.pop(context),
            text: "닫기",
          ),
        ],
      ),
    ),
  );
}

class MyPetModal extends StatefulWidget {
  MyPetModal({
    super.key,
    required this.screen,
    required this.pet,
    required this.content,
    required this.title,
    this.backgroud,
  });

  final Size screen;
  final Item pet;
  final Widget content;
  final Widget? backgroud;
  final String? title;

  final Map<String, Map<String, dynamic>> petModels = {
    '비석_00': {
      'src': 'assets/tomb.glb',
      'motions': ['Idle']
    },
    '구미호_01': {
      'src': 'assets/pets/small_fox.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    '구미호_02': {
      'src': 'assets/pets/mid_fox.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    '구미호_03': {
      'src': 'assets/pets/kitsune.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
  };

  @override
  State<MyPetModal> createState() => _MyPetModalState();
}

class _MyPetModalState extends State<MyPetModal> {
  bool? waiting = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.screen.height * 0.6,
        maxWidth: widget.screen.width * 0.8,
      ),
      child: Stack(children: [
        widget.backgroud ?? SizedBox.shrink(),
        Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xfff08636), // FIXME: 색 변경 테스트
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                widget.title ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: widget.screen.width * 0.5,
                child: Image.asset(
                  'assets/pets/kitsune_jump.gif',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: widget.content,
            ),
          ],
        ),
      ]),
    );
  }
}
