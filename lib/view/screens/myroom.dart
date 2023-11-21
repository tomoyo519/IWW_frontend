import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:iww_frontend/view/widget/bottombar.dart';

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
      // layer of 3d objects
      // TODO 오브젝트 위치를 어떻게 이동시킬지 고민해보자
      ModelViewer(
        // loading: Loading.eager,
        shadowIntensity: 1,
        src: 'assets/koi_fish.glb',
        alt: 'koi fish',
        autoPlay: true,
        disableZoom: true,
        cameraControls: false,
        animationName: "morphBake",
        cameraOrbit: "30deg 60deg 0m", // theta, phi, radius
        cameraTarget: "4m 6m 2m", // x(왼쪽 위), y(높이) ,z (오른쪽 위)
      ),
      ModelViewer(
        // loading: Loading.eager,
        shadowIntensity: 1,
        src: 'assets/Astronaut.glb',
        alt: 'astronaut',
        // autoRotate: true,
        autoPlay: true,
        disableZoom: true,
        cameraControls: false,
        // animationName: "walk",
        cameraOrbit: "30deg 60deg 0m", // theta, phi, radius
        cameraTarget: "1m 4m 4m", // x(왼쪽 위), y(높이) ,z (오른쪽 위)
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

// class MyRoom extends StatelessWidget {`
//   final UserRepository userRepository;
//   MyRoom(this.userRepository, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     CommentsProvider commentsProvider = CommentsProvider();

//     final userId = ModalRoute.of(context)!.settings.arguments as String;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Room'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             int? currentUserId = await userRepository.getUserId();
//             showCommentsBottomSheet(
//                 context, commentsProvider, currentUserId.toString(), userId);
//           },
//           child: Text('방명록 보기'),
//         ),
//       ),
//     );
//   }
// }
