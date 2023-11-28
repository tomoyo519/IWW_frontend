import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MyRoomViewModel with ChangeNotifier {
  int _roomOwner = 0;

  final Map<String, AssetImage> _backgrounds = {
    'bg1': AssetImage('assets/bg/bg1.png'),
    'bg2': AssetImage('assets/bg/bg2.png'),
    'bg3': AssetImage('assets/bg/bg3.png'),
    'bg4': AssetImage('assets/bg/bg4.png'),
    'bg5': AssetImage('assets/bg/bg5.png'),
    'bg6': AssetImage('assets/bg/bg6.png'),
    'bg7': AssetImage('assets/bg/bg7.jpeg'),
  };

  // TODO get assets from DB
  final Map<String, dynamic> _assets = {
    'cat': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/cat.glb',
      alt: 'cuttest pet ever',
      // autoRotate: true,
      autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      cameraOrbit: "30deg,180deg, 0m",
      cameraTarget: "0m 300m 300m",
      disableZoom: true,
    ),
    'kitsune': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/pets/kitsune.glb',
      alt: 'kitsune',
      // autoRotate: true,
      autoPlay: true,
      animationName: "walk",
      cameraOrbit: "30deg, 0deg, 0m",
      cameraTarget: "0m 1m 0.4m",
      disableZoom: true,
    ),
    'kitsune_ani': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/pets/kitsune_ani.glb',
      alt: 'kitsune',
      // autoRotate: true,
      // autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      cameraOrbit: "330deg, 0deg, 0m",
      cameraTarget: "0m 2m 1m",
      disableZoom: true,
    ),
    'small_fox': ModelViewer(
      loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/pets/small_fox.glb',
      alt: 'kitsune',
      // autoRotate: true,
      autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      animationName: "Jump",
      cameraTarget: "0.3m 1.1m 0.7m",
      interactionPrompt: InteractionPrompt.none,
      cameraOrbit: "330deg,0deg, 0m",
      disableZoom: true,
    ),
    'mid_fox': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/pets/mid_fox.glb',
      alt: 'kitsune',
      // autoRotate: true,
      autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      cameraTarget: "0m 0.8m 0.4m",
      animationName: "Idle_A",
      cameraOrbit: "30deg, 150deg, 0m",
      interactionPrompt: InteractionPrompt.none,
      disableZoom: true,
    ),
  };

  set roomOwner(int roomOwnerId) {
    _roomOwner = roomOwnerId;
  }

  bool isMyRoom() => _roomOwner == 0;

  // 방에 놓을 오브젝트들
  List<Widget> getObjects() {
    if (isMyRoom()) {
      return [_assets['small_fox']!];
    } else {
      return [_assets['small_fox']!, _assets['mid_fox']!];
    }
  }

  AssetImage getBackground() {
    if (isMyRoom()) {
      return _backgrounds['bg1']!;
    } else {
      return _backgrounds['bg5']!;
    }
  }
}
