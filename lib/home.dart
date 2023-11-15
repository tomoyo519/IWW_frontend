import 'package:flutter/material.dart';
import 'appbar.dart';
import 'bottombar.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Stack(children: [
        Positioned(
            child: Image.asset('assets/background.png'), top: 50, left: 30),
        Expanded(
            child: ModelViewer(
          loading: Loading.eager,
          shadowIntensity: 1,

          // skyboxImage:
          //     "https://modelviewer.dev/shared-assets/environments/spruit_sunrise_1k_HDR.hdr",
          src: 'assets/cat.glb',
          alt: 'A 3D model of an astronaut',
          autoRotate: true,
          autoPlay: true,
          iosSrc: 'assets/cat2.usdz',
          disableZoom: true,
        )),
      ]),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
