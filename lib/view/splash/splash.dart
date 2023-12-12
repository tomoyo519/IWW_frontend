import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:iww_frontend/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/splash/DoWith_splash.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
        _controller!.setLooping(false);

        // 동영상 상태 감시를 위한 리스너 추가
        _controller!.addListener(checkVideo);
      });
  }

  void checkVideo() {
    if (!_controller!.value.isPlaying &&
        _controller!.value.position == _controller!.value.duration) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RenderPage()));
      _controller!.removeListener(checkVideo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller!.value.isInitialized
          ? VideoPlayer(_controller!)
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
