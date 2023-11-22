import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class revivalPet extends StatelessWidget {
  const revivalPet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        const ModelViewer(
          loading: Loading.eager,
          shadowIntensity: 1,
          src: 'assets/cat.glb',
          alt: '다시 살아난 너의 펫',
          autoRotate: true,
          autoPlay: true,
          iosSrc: 'assets/cat2.usdz',
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
