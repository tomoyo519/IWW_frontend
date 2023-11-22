import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/widget/guestbook.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:iww_frontend/view/widget/bottombar.dart';
import 'package:provider/provider.dart';

class MyRoom extends StatelessWidget {
  MyRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 의존성
    final authService = Provider.of<AuthService>(context, listen: false);
    final roomRepository = Provider.of<RoomRepository>(context, listen: false);
    final commentRepository =
        Provider.of<CommentRepository>(context, listen: false);
    return Scaffold(
        body: ChangeNotifierProvider<CommentsProvider>(
          create: (context) =>
              CommentsProvider(authService, roomRepository, commentRepository),
          child: RenderMyRoom(),
        ),
        bottomNavigationBar: MyBottomNav());
  }
}

class RenderMyRoom extends StatelessWidget {
  const RenderMyRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommentsProvider commentsProvider = context.read<CommentsProvider>();
    // final userId = ModalRoute.of(context)!.settings.arguments as String;

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
            ElevatedButton(
                // onPressed: () {},
                onPressed: () async {
                  int? currentUserId = await commentsProvider.getUserId();
                  String? roomOwenerId = commentsProvider.roomOwnerId;

                  if (context.mounted) {
                    showCommentsBottomSheet(context, commentsProvider,
                        currentUserId.toString(), roomOwenerId);
                  }
                },
                child: Text('방명록')),
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

// class MyRoom extends StatefulWidget {
//   MyRoom({Key? key}) : super(key: key);

//   @override
//   State<MyRoom> createState() => _MyRoomState();
// }

// class _MyRoomState extends State<MyRoom> {
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
//             int? currentUserId = await UserRepository.getUserId();
//             if (mounted) {
//               showCommentsBottomSheet(
//                   context, commentsProvider, currentUserId.toString(), userId);
//             }
//           },
//           child: Text('방명록 보기'),
//         ),
//       ),
//     );
//   }
// }
