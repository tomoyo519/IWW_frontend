import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Pet extends StatelessWidget {
  const Pet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        const ModelViewer(
          loading: Loading.eager,
          shadowIntensity: 1,
          src: 'assets/cat.glb',
          alt: 'cuttest pet ever',
          autoRotate: true,
          autoPlay: true,
          iosSrc: 'assets/cat2.usdz',
          disableZoom: true,
        ),
      ]),
    );
  }
}
