import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/modals/custom_alert_dialog.dart';
import 'package:iww_frontend/view/myroom/mypet.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

void showTodoDoneModal(BuildContext context) {
  Size screen = MediaQuery.of(context).size;
  Item pet = context.read<UserInfo>().mainPet;

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

  showCustomAlertDialog(
    context: context,
    actions: null,
    content: MyPetModal(
      screen: screen,
      petModels: petModels,
      pet: pet,
    ),
  );
}

class MyPetModal extends StatefulWidget {
  const MyPetModal({
    super.key,
    required this.screen,
    required this.petModels,
    required this.pet,
  });

  final Size screen;
  final Map<String, Map<String, dynamic>> petModels;
  final Item pet;

  @override
  State<MyPetModal> createState() => _MyPetModalState();
}

class _MyPetModalState extends State<MyPetModal> {
  bool waiting = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      constraints: BoxConstraints(
        maxHeight: widget.screen.height * 0.6,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            // height: widget.screen.height * 0.3,
            child: ModelViewer(
              interactionPrompt: InteractionPrompt.none,
              src: widget.petModels[widget.pet.name]!['src'],
              autoPlay: true,
              animationName: 'Jump',
              cameraControls: false,
              cameraOrbit: '25deg 75deg 105%',
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              constraints: BoxConstraints(
                minHeight: 300,
              ),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("오늘의 첫 번째 할일을 완료했어요!"),
                  ),
                  MyButton(
                    full: true,
                    onpressed: (_) => Navigator.pop(context),
                    text: "닫기",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
