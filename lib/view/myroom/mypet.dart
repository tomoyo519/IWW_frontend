import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MyPet extends StatefulWidget {
  final String newSrc;

  const MyPet({Key? key, required this.newSrc}) : super(key: key);

  @override
  State<MyPet> createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  Map<String, String> petModels = {
    '구미호_01': 'assets/pets/small_fox.glb',
    '구미호_02': 'assets/pets/mid_fox.glb',
    '구미호_03': 'assets/pets/kitsune.glb',
  };

  @override
  Widget build(BuildContext context) {
    LOG.log('[마이펫 렌더링] src: ${widget.newSrc}');

    return ModelViewer(
      key: ValueKey(widget.newSrc),
      src: petModels[widget.newSrc]!,
      interactionPrompt: InteractionPrompt.none,
      autoPlay: true,
      autoRotate: true,
      shadowIntensity: 1,
      disableZoom: true,
      cameraControls: false,
      animationName: "Walk",
      cameraTarget: "0.7m 0.7m 0m", // x, y, z
      cameraOrbit: "0deg 70deg 8m",
      autoRotateDelay: 0,
      rotationPerSecond: "0.6rad",
    );
  }
}
