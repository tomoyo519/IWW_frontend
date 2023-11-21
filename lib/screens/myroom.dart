import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:iww_frontend/bottombar.dart';

class MyRoom extends StatelessWidget {
  const MyRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: RenderMyRoom(), bottomNavigationBar: MyBottomNav());
  }
}

class RenderMyRoom extends StatelessWidget {
  const RenderMyRoom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Image.asset(
        'assets/background.png',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
      ),
      ModelViewer(
        // loading: Loading.eager,
        shadowIntensity: 1,
        src: 'assets/Astronaut.glb',
        alt: 'cuttest pet ever',
        // autoRotate: true,
        autoPlay: true,
        disableZoom: true,
        cameraControls: false,
        animationName: "walk",
        cameraOrbit: "30deg 60deg 2m", // theta, phi, radius
        cameraTarget: "1m 2m 2m", // x, y ,z
      ),
      Positioned(
        bottom: 0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: () {}, child: Text('방명록')),
            SizedBox(width: 20),
            ElevatedButton(onPressed: () {}, child: Text('인벤토리')),
            SizedBox(width: 20),
            ElevatedButton(onPressed: () {}, child: Text('친구목록')),
          ],
        ),
      )
    ]);
  }
}
