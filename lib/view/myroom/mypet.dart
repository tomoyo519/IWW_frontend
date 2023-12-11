import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
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
  const MyPet({super.key});

  @override
  State<MyPet> createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  final Map<String, Preset> presets = {
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
    'small_fox': {
      'src': 'assets/pets/small_fox.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    'mid_fox': {
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
    'kitsune': {
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
    'monitor_lizard': {
      'src': 'assets/pets/monitor_lizard.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    'horned_lizard': {
      'src': 'assets/pets/horned_lizard.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    'chinese_dragon': {
      'src': 'assets/pets/chinese_dragon.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    'pink_robin': {
      'src': 'assets/pets/pink_robin.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    'archers_buzzard': {
      'src': 'assets/pets/archers_buzzard.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
    'phoenix': {
      'src': 'assets/pets/pheonix.glb',
      'motions': ['Idle', 'Walk', 'Jump']
    },
  };

  void happyMotion() {
    int time = 0;

    Timer.periodic(Duration(seconds: 2), (timer) {
      time += 1;
      setState(() {
        _petActionIndex = 2; // JUMP
      });

      if (time >= 3) {
        timer.cancel();
        setState(() {
          _petActionIndex = 0; // IDLE
        });
      }
    });
  }


  int _petActionIndex = 1;

  @override
  Widget build(BuildContext context) {
    final myRoomState = context.watch<MyRoomViewModel>();

    // 모델 및 프리셋 선택
    String petName = myRoomState.findPetAsset(); // not nickname
    Map<String, dynamic> selectedModel = petModels[petName]!;
    Preset p = presets[selectedModel['motions']![_petActionIndex]]!;
    // FIXME 펫 체력상태 확인
    bool isDead = false;

    // FIXME log 확인용
    LOG.log('[마이펫 렌더링]');

    // 펫이 죽었으므로 비석 렌더링
    if (isDead) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: IgnorePointer(
          ignoring: true,
          child: ModelViewer(
            key: ValueKey('비석'),
            src: 'assets/tomb.glb',
            animationName: 'Idle',
            cameraTarget: '0.3m 0.9m 0.4m',
            cameraOrbit: '30deg 80deg 8m',
            autoRotate: false,
            rotationPerSecond: '0rad',
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
      // 펫이 잘 살아 있으면 펫 렌더링
    } else {
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
                key: ValueKey('$petName - $_petActionIndex'),
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
}
