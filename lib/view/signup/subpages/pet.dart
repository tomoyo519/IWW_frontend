import 'package:flutter/material.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/style/textfield.dart';
import 'package:iww_frontend/viewmodel/signup.viewmodel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<SignUpViewModel>();
    final screen = MediaQuery.of(context).size;

    return SizedBox(
      width: screen.width,
      // height: screen.height,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: ModelViewer(
              src: 'assets/pets/kitsune.glb',
              interactionPrompt: InteractionPrompt.none,
              autoPlay: true,
              // autoRotate: true,
              shadowIntensity: 1,
              disableZoom: true,
              cameraControls: false,
              animationName: "Idle_A",
              cameraTarget: "0.5m 0.5m 0m", // x, y, z
              // cameraOrbit: "-10deg 70deg 0.5m",
              autoRotateDelay: 0,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Text(
                      "여정을 시작할 준비가 되셨나요?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "첫 번째 펫을 만나보아요. 이름을 지어주세요.",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                MyTextField(
                  label: "이름이 무엇인가요?",
                  textAlign: TextAlign.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  onchange: (value) {
                    viewmodel.petName = value;
                  },
                ),
                MyButton(
                  type: viewmodel.petName.isEmpty
                      ? MyButtonType.disabled
                      : MyButtonType.primary,
                  full: true,
                  text: "이대로 시작!",
                  onpressed: (context) {
                    viewmodel.signUp();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
