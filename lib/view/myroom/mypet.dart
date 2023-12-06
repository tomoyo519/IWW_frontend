import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

class Preset {
  final String animationName;
  final String cameraOrbit;
  final String cameraTarget;
  final bool autoRotate;
  final String rotationPerSecond;

  Preset({
    required this.animationName,
    required this.cameraOrbit,
    required this.cameraTarget,
    required this.autoRotate,
    required this.rotationPerSecond,
  });
}


class MyPet extends StatefulWidget {
  final String newSrc;

  const MyPet({Key? key, required this.newSrc}) : super(key: key);

  @override
  State<MyPet> createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  int _petActionIndex = 1;

  final Map<String, Preset> presets = {
    'Idle': Preset(
        animationName: 'Idle',
        cameraOrbit: '30deg 80deg 8m',
        cameraTarget: '0.1m 1.2m 0.3m',
        autoRotate: false,
        rotationPerSecond: '0rad'),
    'Walk': Preset(
      animationName: 'Walk',
      cameraOrbit: '0deg 70deg 8m',
      cameraTarget: '0.7m 0.7m 0m',
      autoRotate: true,
      rotationPerSecond: '0.6rad',
    ),
    'Jump': Preset(
        animationName: 'Jump',
        cameraOrbit: '30deg 80deg 0m',
        cameraTarget: '0.5m 0.7m 0.8m',
        autoRotate: false,
        rotationPerSecond: '0rad'),
  };

  final Map<String, Map<String, dynamic>> petModels = {
    '비석': {
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
  Widget build(BuildContext context) {
    // 모델 및 프리셋 선택
    String targetResouce = '${widget.newSrc}_$_petActionIndex';
    Map<String, dynamic> selectedModel = petModels[widget.newSrc]!;
    Preset p = presets[selectedModel['motions']![_petActionIndex]]!;

    // 체력이 0이면 비석으로 변경
    var userInfo = context.watch<UserInfo>();
    LOG.log('[마이펫 렌더링] key: $targetResouce');

    if (userInfo.userHp == 0) {
      selectedModel = petModels['비석']!;
      p = presets[selectedModel['motions']![0]]!;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        LOG.log('아니 왜 안바뀌는데 $_petActionIndex');
        setState(() {
          _petActionIndex =
              (_petActionIndex + 1) % selectedModel['motions']!.length as int;
        });
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: ModelViewer(
          key: ValueKey(targetResouce),
          src: selectedModel['src'],
          animationName: p.animationName,
          cameraTarget: p.cameraTarget,
          cameraOrbit: p.cameraOrbit,
          autoRotate: p.autoRotate,
          rotationPerSecond: p.rotationPerSecond,
          // 이하 고정값
          interactionPrompt: InteractionPrompt.none,
          cameraControls: false,
          autoPlay: true,
          shadowIntensity: 1,
          disableZoom: true,
          autoRotateDelay: 0,
        ),
      ),
    );
  }
}
