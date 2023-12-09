import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/guestbook/guestbook.dart';
import 'package:iww_frontend/view/inventory/newinventory.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/view/myroom/render_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MyRoom extends StatelessWidget {
  const MyRoom({super.key});

  @override
  Widget build(BuildContext context) {
    // 의존성
    final userId = context.read<UserInfo>().userId;
    final roomRepository = Provider.of<RoomRepository>(context, listen: false);
    final commentRepository =
        Provider.of<CommentRepository>(context, listen: false);

    // 내비게이터 설정
    final nav = context.read<AppNavigator>();
    int roomOwner = nav.arg != null ? int.parse(nav.arg!) : userId;
    nav.title = '친구의방';

    LOG.log('Room page: user id $userId, owner id $roomOwner');

    return MultiProvider(providers: [
      ChangeNotifierProvider<CommentsProvider>(
          create: (_) => CommentsProvider(
                userId.toString(),
                userId.toString(),
                commentRepository,
              )),
      ChangeNotifierProvider<MyRoomViewModel>(
          create: (_) => MyRoomViewModel(userId, roomRepository, roomOwner)),
      ChangeNotifierProvider(create: (_) => MyRoomState()),
    ], child: MyRoomPage());
  }
}

// 인벤토리 뷰 토글을 위한 상태관리
class MyRoomState extends ChangeNotifier {
  // TODO 필요에 따라서 사용
}

// 마이룸 기본 페이지
class MyRoomPage extends StatefulWidget {
  const MyRoomPage({super.key});

  @override
  State<MyRoomPage> createState() => _MyRoomPageState();
}

class _MyRoomPageState extends State<MyRoomPage> {
  int _selectedIndex = 0;

  bool isSheetOpen = false;

  void _showInventorySheet() {
    setState(() {
      isSheetOpen = !isSheetOpen;
    });
  }

  void _showComments() {
    final commentsProvider =
        Provider.of<CommentsProvider>(context, listen: false);
    showCommentsBottomSheet(context, commentsProvider);
  }

  @override
  Widget build(BuildContext context) {
    var myRoomViewModel = Provider.of<MyRoomViewModel>(context);
    var colorScheme = Theme.of(context).colorScheme;

    // 테마 컬러 적용 (배경색`)
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: getPage(_selectedIndex),
      ),
    );

    // return Scaffold(
    //   body: mainArea,
    //   // 페이지 중앙왼쪽 각종 버튼
    //   floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    //   floatingActionButton: Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       FloatingActionButton(

    //           child: Column(
    //             children: const [
    //              ,
    //               Text('마이홈'),
    //             ],
    //           ),
    //           onPressed: () => setState(() {
    //                 _selectedIndex = 0;
    //               })),
    //       const SizedBox(height: 10),

    // return Scaffold(
    //   floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    //   // 페이지 중앙왼쪽 각종 버튼
    //   floatingActionButton: Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       FloatingActionButton(
    //           child: Column(
    //             children: const [
    //               Icon(Icons.note),
    //               Text('마이홈'),
    //             ],
    //           ),
    //           onPressed: () => setState(() {
    //                 _selectedIndex = 0;
    //               })),
    //       const SizedBox(height: 10),
    //       FloatingActionButton(
    //         // onPressed: () => showInventorySheet(context),
    //         onPressed: toggleSheet,
    //         child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: const [
    //               Icon(Icons.inventory_2_rounded),
    //               Text('인벤토리')
    //             ]),
    //       ),
    //       const SizedBox(height: 10),
    //       FloatingActionButton(
    //         onPressed: _showComments,
    //         child: Column(
    //           children: const [
    //             Icon(Icons.note),
    //             Text('방명록'),
    //           ],
    //         ),
    //       ),
    //       const SizedBox(height: 10),
    //       FloatingActionButton(
    //           child: Column(
    //             children: const [
    //               Icon(Icons.group),
    //               Text('친구목록'),
    //             ],
    //           ),
    //           onPressed: () => setState(() {
    //                 _selectedIndex = 3;
    //               })),
    //     ],
    //   ),
  //     body: Stack(children: [
  //       mainArea,
  //       if (isSheetOpen) inventorySheet(context, myRoomViewModel),
  //       ],
  //     ),
  //   );
  // }
    return Scaffold(
      body: Stack(
        children: [
          mainArea,
          if (isSheetOpen) inventorySheet(context, myRoomViewModel),
        ],
      ),
      floatingActionButton: buildSpeedDial(),
    );
  }

  // NOTE 페이지 인덱스에 따라서 페이지를 반환합니다.
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return RenderPage();
      // case 1:
      //   return InventoryPage();
      default:
        return Center(
            child: SizedBox(
                height: 300, width: 300, child: Text('페이지를 찾을 수 없습니다.')));
    }
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      overlayOpacity: 0.0,
      animatedIcon: AnimatedIcons.view_list,
      children: [
        SpeedDialChild(
          shape: CircleBorder(),
          child: CircleAvatar(
            // 원형 아이콘
            backgroundColor: Colors.white,
            child: Icon(Icons.home),
          ),
          // label: '마이홈',
          // labelBackgroundColor: Colors.green, // 투

          onTap: () => setState(() {
            _selectedIndex = 0;
          }),
        ),
        SpeedDialChild(
          shape: CircleBorder(),
          onTap: _showInventorySheet,
          child: CircleAvatar(
            backgroundColor: (Colors.white),
            child: Icon(Icons.backpack),
          ),
          // label: '인벤토리',
        ),
        SpeedDialChild(
          shape: CircleBorder(),
          // label: '방명록',
          onTap: _showComments,
          child: Icon(Icons.local_post_office),
        ),
        SpeedDialChild(
          shape: CircleBorder(),
          child: Icon(Icons.group),
          // label: '친구목록',
          onTap: () => setState(() {
            _selectedIndex = 3;
          }),
        ),
      ],
      child: Icon(Icons.menu),
    );
  }

  //       FloatingActionButton(
  //           child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: const [
  //               ,
  //                 Text('인벤토리')
  //               ]),
  //           onPressed: () => setState(() {
  //                 _selectedIndex = 1;
  //               })),
  //       const SizedBox(height: 10),
  //       FloatingActionButton(
  //           child: Column(
  //             children: const [
  //               Icon(Icons.note),
  //               Text('방명록'),
  //             ],
  //           ),
  //           onPressed: () => setState(() {
  //                 _selectedIndex = 2;
  //               })),
  //       const SizedBox(height: 10),
  //       FloatingActionButton(
  //           child: Column(
  //             children: const [
  //               Icon(Icons.group),
  //               Text('친구목록'),
  //             ],
  //           ),
  //           onPressed: () => setState(() {
  //                 _selectedIndex = 3;
  //               })),
  //     ],
  //   ),
  // );
}

// NOTE 페이지 인덱스에 따라서 페이지를 반환합니다.
// Widget getPage(int index) {
//   switch (index) {
//     case 0:
//       return RenderPage();
//     // case 1:
//     //   return InventoryPage();
//     default:
//       return Center(
//           child: SizedBox(
//               height: 300, width: 300, child: Text('페이지를 찾을 수 없습니다.')));
//   }
// }