import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/widget/guestbook.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:iww_frontend/view/widget/bottombar.dart';
import 'package:provider/provider.dart';
import 'dart:async';

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
            child: ChangeNotifierProvider<MyRoomState>(
              create: (context) => MyRoomState(),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(flex: 1, child: RenderMyRoom()),
                    UnderLayer(),
                    BottomButtons(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )),
        bottomNavigationBar: MyBottomNav());
  }
}

class MyRoomState extends ChangeNotifier {
  bool isMyRoom = true;

  void toggleRoom() {
    isMyRoom = !isMyRoom;
    notifyListeners();
  }
}

class RenderMyRoom extends StatelessWidget {
  RenderMyRoom({Key? key}) : super(key: key);

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
      src: 'assets/koi_fish.glb',
      alt: 'astronaut',
      // autoRotate: true,
      autoPlay: true,
      disableZoom: true,
      cameraControls: false,
      // animationName: "walk",
      cameraOrbit: "40deg 60eg 0m",
      // theta, phi, radius
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
      cameraOrbit: "30deg 60deg 0m",
      // theta, phi, radius
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
      cameraOrbit: "30deg 30deg 2m",
      // theta, phi, radius
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

  @override
  Widget build(BuildContext context) {
    var myRoomState = context.watch<MyRoomState>();
    final authService = Provider.of<AuthService>(context);
    final commentsProvider = context.read<CommentsProvider>();

    // get argument from navigator, context
    try {
      myRoomState.isMyRoom = ModalRoute.of(context)!.settings.arguments as bool;
    } catch (e) {
      print(e);
    }

    Stack layers = Stack(alignment: Alignment.center, children: []);

    /* am i in my room? */
    if (myRoomState.isMyRoom) {
      layers.children.add(sources['bg1']!);
      layers.children.add(sources['fish']!);
      layers.children.add(sources['cat']!);
    } else {
      layers.children.add(sources['bg2']!);
      layers.children.add(sources['fish']!);
      layers.children.add(sources['astronaut']!);
    }

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

class UnderLayer extends StatelessWidget {
  UnderLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myRoomState = context.watch<MyRoomState>();

    return SizedBox(
      height: 200,
      child:
          myRoomState.isMyRoom ? StatusBar() : SizedBox(height: 150, width: 20),
      // BottomButtons()
    );
  }
}

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> with TickerProviderStateMixin {
  Timer? _timer;
  var _hp = 0.3;
  var _exp = 0.1;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Call _setHP method here to update the hp value every 5 seconds
      setState(() {
        _hp >= 1 ? _hp : _hp += 0.1;
        _exp >= 1 ? _exp : _exp += 0.2;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: const [
                SizedBox(width: 10),
                Text(
                  'HP',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.left,
                )
              ],
            ),
            LinearProgressIndicator(
              value: _hp,
              minHeight: 14,
              valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 239, 118, 110)),
              backgroundColor: Colors.grey[200],
              semanticsLabel: 'Linear progress indicator',
            ),
            Row(
              children: const [
                SizedBox(width: 10),
                Text(
                  'EXP',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.left,
                )
              ],
            ),
            LinearProgressIndicator(
              value: _exp,
              minHeight: 14,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 155, 239, 110)),
              backgroundColor: Colors.grey[200],
              semanticsLabel: 'Linear progress indicator',
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    var myRoomState = context.watch<MyRoomState>();

    // NOTE 여기서 비동기 연산 수행
    final authService = Provider.of<AuthService>(context);
    final commentsProvider = context.read<CommentsProvider>();

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
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
                    context, '/friends', (Route<dynamic> route) => false);
              },
              child: Text('친구목록')),
        ],
      ),
    );
  }
}


  //  // bottom buttons
  //   layers.children.add(Positioned(
  //     bottom: 0,
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         ElevatedButton(
  //             onPressed: () async {
  //               String? roomOwenerId = commentsProvider.roomOwnerId;

  //               final currentUser = await authService.getCurrentUser();
  //               // 로그인 유저 없으면 6
  //               var userId = (currentUser != null)
  //                   ? currentUser.user_id.toString()
  //                   : '6';

  //               if (context.mounted) {
  //                 showCommentsBottomSheet(
  //                   context,
  //                   commentsProvider,
  //                   userId,
  //                   roomOwenerId,
  //                 );
  //               }
  //             },
  //             child: Text('방명록')),
  //         SizedBox(width: 20),
  //         ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/inventory');
  //             },
  //             child: Text('인벤토리')),
  //         SizedBox(width: 20),
  //         ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamedAndRemoveUntil(
  //                 context, '/friends', (Route<dynamic> route) => false);
  //             },
  //             child: Text('친구목록')),
  //       ],
  //     ),
  //   ));
