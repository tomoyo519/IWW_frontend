import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class EvolPet extends StatelessWidget {
  const EvolPet({
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
          alt: 'cuttest pet ever',
          autoRotate: true,
          autoPlay: true,
          iosSrc: 'assets/cat2.usdz',
          disableZoom: true,
        ),
        Image.asset('assets/evolution.gif',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height),
      ]),
    );
  }
}
