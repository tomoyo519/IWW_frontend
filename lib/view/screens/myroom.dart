import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/widget/guestbook.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:iww_frontend/view/widget/bottombar.dart';
import 'package:provider/provider.dart';

class MyRoom extends StatelessWidget {
  const MyRoom({super.key});

  @override
  Widget build(BuildContext context) {
    // 의존성
    final authService = Provider.of<AuthService>(context, listen: false);
    final roomRepository = Provider.of<RoomRepository>(context, listen: false);
    final commentRepository =
        Provider.of<CommentRepository>(context, listen: false);

    return Scaffold(
        body: ChangeNotifierProvider<CommentsProvider>(
            create: (context) => CommentsProvider(
                  authService,
                  roomRepository,
                  commentRepository,
                ),
            child: RenderMyRoom()),
        bottomNavigationBar: MyBottomNav());
  }
}

class RenderMyRoom extends StatelessWidget {
  RenderMyRoom({Key? key}) : super(key: key);

  bool _isMyRoom = true;

  var sources = {
    'bg1': Image.asset(
      'assets/background.png',
      fit: BoxFit.cover,
    ),
    'bg2': Image.asset(
      'assets/bg2.png',
      height: 500,
      fit: BoxFit.fill,
    ),
    'fish': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/koi_fish.glb',
      alt: 'koi fish',
      autoPlay: true,
      disableZoom: true,
      cameraControls: false,
      animationName: 'morphBake',
      cameraOrbit: '30deg 60deg 0m',
      cameraTarget: '4m 6m 2m',
    ),
    'astronaut': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/Astronaut.glb',
      alt: 'astronaut',
      // autoRotate: true,
      autoPlay: true,
      disableZoom: true,
      cameraControls: false,
      // animationName: "walk",
      cameraOrbit: "40deg 60eg 0m", // theta, phi, radius
      cameraTarget: "0.5m 1.5m 2m", // x(왼쪽 위), y(높이) ,z (오른쪽 위)
    ),
    'robot': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/robot_walk_idle.usdz',
      alt: 'robot',
      // autoRotate: true,
      autoPlay: true,
      disableZoom: true,
      cameraControls: false,
      animationName: "walk",
      cameraOrbit: "30deg 60deg 0m", // theta, phi, radius
      cameraTarget: "1m 4m 4m", // x(왼쪽 위), y(높이) ,z (오른쪽 위)
    ),
    'animals': ModelViewer(
      // loading: Loading.eager,
      // shadowIntensity: 1,
      src: 'assets/aa.glb',
      alt: 'animals',
      // autoRotate: true,
      autoPlay: true,
      disableZoom: true,
      // cameraControls: false,
      // animationName: "walk",
      cameraOrbit: "30deg 30deg 2m", // theta, phi, radius
      cameraTarget: "2m 2m 2m", // x(왼쪽 위), y(높이) ,z (오른쪽 위)
    ),
    'cat': ModelViewer(
      // loading: Loading.eager,
      shadowIntensity: 1,
      src: 'assets/cat.glb',
      alt: 'cuttest pet ever',
      // autoRotate: true,
      autoPlay: true,
      // iosSrc: 'assets/cat2.usdz',
      cameraOrbit: "30deg,180deg, 0m",
      cameraTarget: "0m 300m 300m",
      disableZoom: true,
    ),
  };

  set _setMyRoom(bool val) {
    _isMyRoom = val;
    print('######## now my room is $_isMyRoom');
  }

  @override
  Widget build(BuildContext context) {
    // 여기서 비동기 연산 수행
    final authService = Provider.of<AuthService>(context);
    final commentsProvider = context.read<CommentsProvider>();

    // set
    try {
      _isMyRoom = ModalRoute.of(context)!.settings.arguments as bool;
    } catch (e) {
      print(e);
    }

    Stack layers = Stack(alignment: Alignment.center, children: []);

    /* am i in my room? */
    if (_isMyRoom) {
      layers.children.add(sources['bg1']!);
      layers.children.add(sources['fish']!);
      layers.children.add(sources['cat']!);
    } else {
      layers.children.add(sources['bg2']!);
      layers.children.add(sources['fish']!);
      layers.children.add(sources['astronaut']!);
    }

    // bottom buttons
    layers.children.add(Positioned(
      bottom: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () async {
                String? roomOwenerId = commentsProvider.roomOwnerId;

                final currentUser = await authService.getCurrentUser();
                // 로그인 유저 없으면 6
                var userId = (currentUser != null)
                    ? currentUser.user_id.toString()
                    : '6';

                if (context.mounted) {
                  showCommentsBottomSheet(
                    context,
                    commentsProvider,
                    userId,
                    roomOwenerId,
                  );
                }
              },
              child: Text('방명록')),
          SizedBox(width: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/inventory');
              },
              child: Text('인벤토리')),
          SizedBox(width: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/myroom",
                    arguments: !_isMyRoom,
                    (route) => false);
              },
              child: Text('친구목록')),
        ],
      ),
    ));

    return layers;
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
