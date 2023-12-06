import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/guestbook/guestbook.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/view/inventory/inventory.dart';
import 'package:iww_frontend/view/myroom/myroom_component.dart';

class MyRoom extends StatelessWidget {
  const MyRoom({super.key});

  @override
  Widget build(BuildContext context) {
    // 의존성
    final userId = context.read<UserInfo>().userId;
    final roomRepository = Provider.of<RoomRepository>(context, listen: false);
    final commentRepository =
        Provider.of<CommentRepository>(context, listen: false);
    final nav = context.read<AppNavigator>();
    int roomOwner = nav.arg != null ? int.parse(nav.arg!) : userId;

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
  double _growth = 0.0;
  final maxGrowth = 350.0;

  get growth => _growth;

  void toggleGrowth() {
    _growth = (growth == 0.0) ? maxGrowth : 0.0;
    notifyListeners();
  }
}

// 마이룸 기본 페이지
class MyRoomPage extends StatelessWidget {
  const MyRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    var myRoomState = context.watch<MyRoomState>();

    return Center(
      child: Stack(fit: StackFit.expand, children: [
        // 마이룸 화면 구성
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
                width: double.infinity,
                height: screenHeight - myRoomState.growth,
                color: Colors.blue,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: MyRoomComponent())),
        // 하단 인벤토리 뷰
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
                width: double.infinity,
                height: myRoomState.growth,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: InventoryView()))
      ]),
    );
  }
}
