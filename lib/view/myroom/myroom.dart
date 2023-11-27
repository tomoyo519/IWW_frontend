import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/guestbook/guestbook.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';

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
            child: ChangeNotifierProvider<MyRoomViewModel>(
              create: (context) => MyRoomViewModel(),
              child: SafeArea(
                child: Stack(
                  children: [
                    RenderMyRoom(),
                    // Positioned(height: 800, bottom: 100, child: UnderLayer()),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 30,
                        height: 150,
                        child: UnderLayer()),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      height: 50,
                      child: BottomButtons(),
                    ),
                  ],
                ),
              ),
            )),
        bottomNavigationBar: MyBottomNav());
  }
}

// 나의 펫 렌더링
class RenderMyRoom extends StatefulWidget {
  const RenderMyRoom({super.key});

  @override
  State<RenderMyRoom> createState() => _RenderMyRoomState();
}

class _RenderMyRoomState extends State<RenderMyRoom> {
  var roomObjects = <Widget>[];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    var roomState = context.watch<MyRoomViewModel>();

    LOG.log(roomState.getRoomObjects.length.toString());

    // Naviator를 통해서 argument를 전달할 경우 받는 방법
    try {
      roomState.isMyRoom = ModalRoute.of(context)!.settings.arguments as bool;
    } catch (e) {
      print("[log/myroom]: $e");
    }

    return Stack(
        alignment: Alignment.center, children: roomState.getRoomObjects);

    // 유저의 펫 정보 불러오기

    /* am i in my room? */
    // if (myRoomState.isMyRoom) {
    //   layers.children.add(sources['bg1']!);
    //   // layers.children.add(sources['mid_fox']!);
    //   layers.children.add(sources['small_fox']!);
    // } else {
    //   layers.children.add(sources['bg2']!);
    //   layers.children.add(sources['mid_fox']!);
    //   layers.children.add(sources['small_fox']!);
    // }
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

  // myroom: status bar, other's room: chatting
  // TODO 채팅 구현 후 채팅창 삽입
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + 30,
      color: Colors.transparent,
      child: context.watch<MyRoomViewModel>().isMyRoom
          ? StatusBar()
          : SizedBox(height: 110, width: 20), // TODO chatting으로 변경
      // BottomButtons()
    );
  }
}

// 펫의 체력, 경험치 표시
class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> with TickerProviderStateMixin {
  Timer? _timer;
  var _hp = 0.3;
  var _exp = 0.1;

  // TODO 할 일을 완료했을때 체력, 경험치가 오르도록 수정 필요
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Call _setHP method here to update the hp value every 5 seconds
      setState(() {
        _hp >= 1 ? _hp : _hp += 0.1;
        _exp >= 1 ? _exp : _exp += 0.2;

        LOG.log("HP: $_hp, EXP: $_exp");
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
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  'HP',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: 30),
              Flexible(
                flex: 8,
                child: LinearProgressIndicator(
                  value: _hp,
                  minHeight: 14,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(255, 239, 118, 110)),
                  backgroundColor: Colors.grey[200],
                  semanticsLabel: 'Linear progress indicator',
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  'EXP',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                flex: 6,
                child: LinearProgressIndicator(
                  value: _exp,
                  minHeight: 14,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 155, 239, 110)),
                  backgroundColor: Colors.grey[200],
                  semanticsLabel: 'Linear progress indicator',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 하단 버튼 세개: 방명록, 인벤토리, 친구목록
class BottomButtons extends StatelessWidget {
  const BottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
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

                final currentUser = authService.user;
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
                // context.read<MyRoomViewModel>().goFriendRoom(1);
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
