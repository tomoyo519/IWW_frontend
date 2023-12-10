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
    if (roomOwner != userId) {
      // 방 주인이 유저가 아니면 홈 라벨 지우기
      nav.title = '';
    }

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

    return Scaffold(
      body: Stack(
        children: [
          mainArea,
          // if (isSheetOpen)
          //   GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         myRoomViewModel.applyChanges();
          //         // myRoomState.toggleGrowth();
          //         userInfo.fetchUser();
          //         isSheetOpen = false; // 탭 시 인벤토리 시트 닫기
          //       });
          //     },
          //     behavior: HitTestBehavior.opaque, // 전체 영역에서 탭 감지
          //     child: Container(
          //       color: Colors.transparent,
          //     ),
          //   ),
          if (isSheetOpen)
            inventorySheet(context, myRoomViewModel, () {
              setState(() {
                isSheetOpen = false; // 인벤토리 시트 닫기
              });
            })
          // if (isSheetOpen) inventorySheet(context, myRoomViewModel),
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
            child: Icon(Icons.work_rounded),
          ),
          // label: '인벤토리',
        ),
        SpeedDialChild(
          shape: CircleBorder(),
          // label: '방명록',
          onTap: _showComments,
          // child: Icon(Icons.local_post_office),
          child: Icon(Icons.comment_rounded),
          // label: '방명록',
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
}
