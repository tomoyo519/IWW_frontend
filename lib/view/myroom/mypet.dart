import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

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
    'Run': Preset(
      animationName: 'Walk',
      cameraOrbit: '0deg 70deg 8m',
      cameraTarget: '0.7m 0.7m 0m',
      autoRotate: true,
      rotationPerSecond: '0.6rad',
    ),
    // 제자리
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
    'Sit': Preset(
      animationName: 'Bounce',
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
    'Eat': Preset(
      animationName: 'Clicked',
      cameraOrbit: '30deg 80deg 0m',
      cameraTarget: '0.5m 0.8m 0.8m',
      autoRotate: false,
      rotationPerSecond: '0rad',
    ),
  };

  // NOTE 모든 모델 파일은 .glb 포맷 사용
  final Map<String, List<String>> motions = {
    'small_fox': ['Idle', 'Walk', 'Jump', 'Spin', 'Clicked'],
    'mid_fox': [
      'Idle',
      'Walk',
      'Jump',
      'Roll',
      'Swim',
      'Spin',
      'Bounce',
      'Clicked'
    ],
    'kitsune': [
      'Idle',
      'Walk',
      'Spin',
      'Jump',
      'Roll',
      'Swim',
      'Bounce',
      'Clicked'
    ],
    'monitor_lizard': ['Idle', 'Walk', 'Jump'],
    'horned_lizard': ['Idle', 'Walk', 'Jump'],
    'chinese_dragon': ['Idle', 'Walk', 'Jump'],
    'pink_robin': ['Idle', 'Walk', 'Jump'],
    'archers_buzzard': [
      'Idle',
      'Walk',
      'Jump',
      'Spin',
      'Bounce',
      'Eat',
      'Clicked',
      'Fly',
      'Roll',
      'Sit',
    ],
    'phoenix': [
      'Idle',
      'Walk',
      'Jump',
      'Clicked',
      'Spin',
      'Fly',
      'Swim',
      'Run',
      'Roll',
      'Bounce',
      'Eat',
      'Sit',
    ],
  };

  void _showOverlay(BuildContext context) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 50, // 화면 중앙으로 위치 지정
        left: MediaQuery.of(context).size.width / 2 - 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Overlay',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry);

    // 일정 시간이 지난 후에 오버레이를 제거할 수 있도록 설정
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void happyMotion(BuildContext context) {
    OverlayEntry overlayEntry;
    final assetsAudioPlayer = AssetsAudioPlayer();

    // 효과음 재생
    assetsAudioPlayer.open(Audio("assets/happy.mp3"));
    assetsAudioPlayer.play();

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.of(context).size.height / 2, // 화면 중앙으로 위치 지정
        left: MediaQuery.of(context).size.width / 2 - 150,
        child: Material(
          color: Colors.transparent,
          child: Image.asset('assets/happy.png', height: 80, width: 80),
        ),
      ),
    );

    int time = 0;
    bool isOverlayAdded = false;

    LOG.log('#### 펫이 통통 튑니다! ####');

    Timer.periodic(Duration(seconds: 2), (timer) {
      time += 1;
      setState(() {
        _petActionIndex = 2; // JUMP
      });

      if (!isOverlayAdded) {
        Overlay.of(context)?.insert(overlayEntry);
        isOverlayAdded = true;
      }

      if (time >= 2) {
        timer.cancel();
        setState(() {
          _petActionIndex = 1; // WALK
        });
        overlayEntry.remove();
      }
    });
  }

  int _petActionIndex = 1;

  @override
  Widget build(BuildContext context) {
    final myRoomState = context.watch<MyRoomViewModel>();
    myRoomState.happyMotion = () => happyMotion(context);

    // 모델 및 프리셋 선택
    String petName = myRoomState.findPetAsset();
    Preset p = presets[motions[petName]![_petActionIndex]]!;
    bool isDead = false; // FIXME 펫 체력상태 확인

    LOG.log('[마이펫 렌더링]'); // FIXME log 확인용

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
              _petActionIndex =
                  (_petActionIndex + 1) % (motions[petName]!.length);
            });
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: IgnorePointer(
              ignoring: true,
              child: ModelViewer(
                key: ValueKey('$petName - $_petActionIndex'),
                src: 'assets/pets/$petName.glb',
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
