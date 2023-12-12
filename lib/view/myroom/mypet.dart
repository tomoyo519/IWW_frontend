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
  MyPet({super.key, required this.firstSrc});

  String firstSrc;

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
      animationName: 'Run',
      cameraOrbit: '0deg 70deg 8m',
      cameraTarget: '0.7m 0.7m 0m',
      autoRotate: true,
      rotationPerSecond: '1.2rad',
    ),
    'Fly': Preset(
      animationName: 'Fly',
      cameraOrbit: '0deg 70deg 8m',
      cameraTarget: '0.7m 0.7m 0m',
      autoRotate: true,
      rotationPerSecond: '1.2rad',
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
      animationName: 'Sit',
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
      animationName: 'Eat',
      cameraOrbit: '30deg 80deg 0m',
      cameraTarget: '0.5m 0.8m 0.8m',
      autoRotate: false,
      rotationPerSecond: '0rad',
    ),
  };

  // NOTE 모든 모델 파일은 .glb 포맷 사용
  final Map<String, List<String>> motions = {
    'small_fox': ['Spin', 'Walk', 'Jump', 'Sit', 'Bounce', 'Idle'],
    'mid_fox': [
      'Spin',
      'Walk',
      'Jump',
      'Roll',
      'Swim',
      'Idle',
      'Bounce',
      'Clicked'
    ],
    'kitsune': [
      'Spin',
      'Walk',
      'Spin',
      'Jump',
      'Sit',
      'Roll',
      'Swim',
      'Bounce',
      'Clicked'
    ],
    'monitor_lizard': ['Spin', 'Walk', 'Jump', 'Idle', 'Bounce', 'Sit'],
    'horned_lizard': ['Spin', 'Walk', 'Jump', 'Idle', 'Bounce', 'Run', 'Roll'],
    'chinese_dragon': ['Spin', 'Walk', 'Jump', 'Idle', 'Bounce'],
    'pink_robin': [
      'Spin',
      'Walk',
      'Jump',
      'Fly',
      'Clicked',
      'Eat',
      'Sit',
    ],
    'archers_buzzard': [
      'Spin',
      'Walk',
      'Jump',
      'Idle',
      'Bounce',
      'Eat',
      'Clicked',
      'Fly',
      'Roll',
      'Sit',
    ],
    'phoenix': [
      'Spin',
      'Walk',
      'Jump',
      'Clicked',
      'Idle',
      'Fly',
      'Swim',
      'Run',
      'Roll',
      'Bounce',
      'Eat',
      'Sit',
    ],
  };

  void happyMotion(BuildContext context) {
    OverlayEntry overlayEntry;
    final assetsAudioPlayer = AssetsAudioPlayer();

    // 효과음 재생
    assetsAudioPlayer.open(Audio("assets/happy.mp3"));
    assetsAudioPlayer.play();

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 + 27, // 화면 중앙으로 위치 지정
        left: MediaQuery.of(context).size.width / 2 - 144,
        child: Material(
          color: Colors.transparent,
          child: Image.asset('assets/happy3.png', height: 100, width: 100),
        ),
      ),
    );

    double time = 0;
    bool isOverlayAdded = false;

    LOG.log('#### 펫이 통통 튑니다! ####');

    Timer.periodic(Duration(milliseconds: 600), (timer) {
      time += 0.6;
      setState(() {
        _petActionIndex = 0; // SPIN
      });

      if (!isOverlayAdded && time >= 0.8) {
        Overlay.of(context)?.insert(overlayEntry);
        isOverlayAdded = true;
      }

      if (time >= 2.4) {
        timer.cancel();
        setState(() {
          _petActionIndex = 1; // WALK
        });
        overlayEntry.remove();
      }
    });
  }

  late String petAsset;
  late Preset p;
  int _petActionIndex = 1;

  @override
  void initState() {
    super.initState();
    petAsset = widget.firstSrc;
    p = presets[motions[petAsset]![_petActionIndex]]!;
    LOG.log('#### 펫이 생성되었습니다! ####');
  }

  @override
  Widget build(BuildContext context) {
    final myRoomState = context.watch<MyRoomViewModel>();
    final userInfo = context.read<UserInfo>();
    myRoomState.happyMotion = () => happyMotion(context);

    petAsset = myRoomState.findPetAsset();
    p = presets[motions[petAsset]![_petActionIndex]]!;

    // 모델 및 프리셋 선택
    bool isDead = (userInfo.userHp == 0); // NOTE 현재는 본인의 체력상태만 가져옵니다.

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
          onTap: () async {
            LOG.log('아니 왜 안바뀌는데 $_petActionIndex');
            setState(() {
              _petActionIndex =
                  (_petActionIndex + 1) % (motions[petAsset]!.length);
            });
            final assetsAudioPlayer = AssetsAudioPlayer();
            assetsAudioPlayer.open(Audio("assets/main.mp3"));
            assetsAudioPlayer.play();
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: IgnorePointer(
              ignoring: true,
              child: ModelViewer(
                key: ValueKey('$petAsset - $_petActionIndex'),
                src: 'assets/pets/$petAsset.glb',
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
