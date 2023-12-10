import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
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
  final bool isDead;

  const MyPet({Key? key, required this.newSrc, required this.isDead})
      : super(key: key);

  @override
  State<MyPet> createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  int _petActionIndex = 1;

  final Map<String, Preset> presets = {
    '비석': Preset(
      animationName: 'Idle',
      cameraOrbit: '30deg 80deg 8m',
      cameraTarget: '0.3m 0.9m 0.4m',
      autoRotate: false,
      rotationPerSecond: '0rad',
    ),
    // 움직임
    'Walk': Preset(
      animationName: 'Walk',
      cameraOrbit: '0deg 70deg 8m',
      cameraTarget: '0.7m 0.7m 0m',
      autoRotate: true,
      rotationPerSecond: '0.6rad',
    ),
    'Roll': Preset(
      animationName: 'Roll',
      cameraOrbit: '0deg 70deg 8m',
      cameraTarget: '0.7m 0.7m 0m',
      autoRotate: true,
      rotationPerSecond: '2rad',
    ),
    'Swim': Preset(
      animationName: 'Swim',
      cameraOrbit: '0deg 70deg 8m',
      cameraTarget: '0.7m 0.7m 0m',
      autoRotate: true,
      rotationPerSecond: '0.6rad',
    ),
    // 이하 제자리
    'Idle': Preset(
      animationName: 'Idle',
      cameraOrbit: '30deg 80deg 0m',
      cameraTarget: '0.5m 0.7m 1m',
      autoRotate: false,
      rotationPerSecond: '0rad',
    ),
    'Jump': Preset(
        animationName: 'Jump',
        cameraOrbit: '30deg 80deg 0m',
      cameraTarget: '0.5m 0.8m 0.8m',
        autoRotate: false,
      rotationPerSecond: '0rad',
    ),
    'Bounce': Preset(
      animationName: 'Bounce',
      cameraOrbit: '30deg 80deg 0m',
      cameraTarget: '0.5m 0.8m 0.8m',
      autoRotate: false,
      rotationPerSecond: '0rad',
    ),
    'Clicked': Preset(
      animationName: 'Clicked',
      cameraOrbit: '30deg 80deg 0m',
      cameraTarget: '0.5m 0.8m 0.8m',
      autoRotate: false,
      rotationPerSecond: '0rad',
    ),
    'Spin': Preset(
      animationName: 'Spin',
      cameraOrbit: '30deg 80deg 0m',
      cameraTarget: '0.5m 0.8m 0.8m',
      autoRotate: false,
      rotationPerSecond: '0rad',
    ),
  };

  final Map<String, Map<String, dynamic>> petModels = {
    '비석_00': {
      'src': 'assets/tomb.glb',
      'motions': ['Idle']
    },
    '기본펫': {
      'src': 'assets/pets/small_fox.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    '구미호_01': {
      'src': 'assets/pets/small_fox.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    '구미호_02': {
      'src': 'assets/pets/mid_fox.glb',
      'motions': [
        'Idle',
        'Walk',
        'Jump',
        'Roll',
        'Swim',
        'Spin',
        'Bounce',
        'Clicked'
      ]
    },
    '구미호_03': {
      'src': 'assets/pets/kitsune.glb',
      'motions': [
        'Idle',
        'Walk',
        'Jump',
        'Roll',
        'Swim',
        'Spin',
        'Bounce',
        'Clicked'
      ]
    },
    '용_01': {
      'src': 'assets/pets/monitor_lizard.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    '용_02': {
      'src': 'assets/pets/horned_lizard.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },    
    '용_03': {
      'src': 'assets/pets/chinese_dragon.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    '불사조_01': {
      'src': 'assets/pets/pink_robin.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    '불사조_02': {
      'src': 'assets/pets/archers_buzzard.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    '불사조_03': {
      'src': 'assets/pets/pheonix.glb',
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
    if (widget.isDead) {
      targetResouce = '비석_00_0';
      selectedModel = petModels['비석_00']!;
      p = presets['비석']!;
    }
    LOG.log('[마이펫 렌더링] key: $targetResouce');

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          LOG.log('아니 왜 안바뀌는데 $_petActionIndex');
          setState(() {
            _petActionIndex = (_petActionIndex + 1) %
                (selectedModel['motions']!.length as int);
          });
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: IgnorePointer(
            ignoring: true,
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
        ));
  }
}
