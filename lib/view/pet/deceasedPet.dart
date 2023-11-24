import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class DeceasedPet extends StatelessWidget {
  const DeceasedPet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        const ModelViewer(
          loading: Loading.eager,
          shadowIntensity: 1,
          src: 'assets/tomb.glb',
          alt: 'yout pet is gone',
          autoRotate: true,
          autoPlay: true,
          iosSrc: 'assets/tomb.usdz',
          disableZoom: true,
        ),
        Image.asset('assets/cloud.gif',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height),
      ]),
    );
  }
}
