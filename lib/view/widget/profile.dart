import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MiniPet extends StatelessWidget {
  const MiniPet({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
      ),
      child: const ModelViewer(
        src: "assets/kitsune.glb",
        animationName: "idle_a",
        interactionPrompt: InteractionPrompt.none,
        disableZoom: true,
        autoPlay: true,
        autoRotate: false,
        cameraControls: false,
        cameraOrbit: '45deg 75deg 4m',
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: MiniPet(),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "프로갓생러",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text("data")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
