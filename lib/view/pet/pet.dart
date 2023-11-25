import 'package:flutter/material.dart';
import 'package:iww_frontend/view/pet/pet_asset_manager.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Pet extends StatelessWidget {
  String src;
  String? alt;
  String? iosSrc;

  Pet({
    Key? key,
    required this.src,
    this.alt,
    this.iosSrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        ModelViewer(
          loading: Loading.eager,
          src: src,
          alt: alt,
          iosSrc: iosSrc,
          autoRotate: true,
          autoPlay: true,
          shadowIntensity: 1,
          disableZoom: true,
        ),
      ]),
    );
  }

  factory Pet.of(int idx) {
    PetAssetInfo? info = PetAssetManager.load(idx);
    if (info == null) {
      // 디폴트 펫
      return Pet(
        src: "assets/small_fox.glb",
      );
    }
    return Pet(
      src: info.src,
      alt: info.alt,
      iosSrc: info.iosSrc,
    );
  }
}
