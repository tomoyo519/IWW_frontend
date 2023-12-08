import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/guestbook/guestbook.dart';
import 'package:iww_frontend/view/inventory/newinventory.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/view/inventory/inventory.dart';
import 'package:iww_frontend/view/myroom/render_page.dart';

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

  void toggleSheet() {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      // 페이지 중앙왼쪽 각종 버튼
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
              child: Column(
                children: const [
                  Icon(Icons.note),
                  Text('마이홈'),
                ],
              ),
              onPressed: () => setState(() {
                    _selectedIndex = 0;
                  })),
          const SizedBox(height: 10),
          FloatingActionButton(
            // onPressed: () => showInventorySheet(context),
            onPressed: toggleSheet,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.inventory_2_rounded),
                  Text('인벤토리')
                ]),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _showComments,
            child: Column(
              children: const [
                Icon(Icons.note),
                Text('방명록'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
              child: Column(
                children: const [
                  Icon(Icons.group),
                  Text('친구목록'),
                ],
              ),
              onPressed: () => setState(() {
                    _selectedIndex = 3;
                  })),
        ],
      ),
      body: Stack(children: [
        mainArea,
        if (isSheetOpen) inventorySheet(context, myRoomViewModel),
        ],
      ),
    );
  }

  // Widget _buildBottomSheet() {
  //   return Positioned(
  //     bottom: 0,
  //     left: 0,
  //     right: 0,
  //     child: Container(
  //       height: 150,
  //       decoration: BoxDecoration(
  //         color: Colors.white54,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: DefaultTabController(
  //         length: 2, // 탭의 수
  //         child: Column(
  //           children: <Widget>[
  //             TabBar(
  //               tabs: const <Widget>[
  //                 Tab(child: Row(children: [Icon(Icons.pets), Text('펫')])),
  //                 Tab(
  //                     child:
  //                         Row(children: [Icon(Icons.inventory), Text('아이템')])),
  //               ],
  //             ),
  //             Expanded(
  //               child: TabBarView(
  //                 children: <Widget>[
  //                   PetTab(), // PET 탭 구현
  //                   ItemTab(), // Item 탭 구현
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
}

// class PetTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // 펫 탭 구현
//     var myRoomViewModel = context.watch<MyRoomViewModel>();
//     // 펫 탭 구현
//     return ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: myRoomViewModel.inventory.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//           onTap: () async {
//             Item i = myRoomViewModel.inventory[index];
//             myRoomViewModel.toggleItem(i);
//           },
//           child: Container(
//             width: 100, // 각 펫 카드의 너비
//             margin: EdgeInsets.symmetric(horizontal: 5),
//             decoration: BoxDecoration(
//               color: myRoomViewModel.roomObjects
//                                 .map((e) => e.id)
//                                 .contains(myRoomViewModel.roomObjects[index].id) ? Colors.blue[100] : Colors.white,
//               border: myRoomViewModel.roomObjects
//                                 .map((e) => e.id)
//                                 .contains(myRoomViewModel.roomObjects[index].id) ? Border.all(color: Colors.blue, width: 2) : null,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: myRoomViewModel.roomObjects
//                                 .map((e) => e.id)
//                                 .contains(myRoomViewModel.roomObjects[index].id) ? [
//                 BoxShadow(
//                   color: Colors.blue.withOpacity(0.5),
//                   spreadRadius: 3,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ] : [],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(myRoomViewModel.inventory[index].name),
//                 Image.asset(
//                   'assets/thumbnail/${myRoomViewModel.inventory[index].path!}',
//                   fit: BoxFit.cover,
//                   height: 80,
//                 )
//                 // 여기에 펫 이미지, 이름 등을 표시
//               ],
//             ),
//           )
//           );

//         });  // 펫 탭 내용
//   }
// }

// class ItemTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // 아이템 탭 구현
//     return Container(); // 아이템 탭 내용
//   }
// }