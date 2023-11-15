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
      body: Column(
        children: [Pet(), Text('미친놈')],
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}

class Pet extends StatelessWidget {
  const Pet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: Stack(children: [
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        ModelViewer(
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
        ),
      ]),
    );
  }
}
