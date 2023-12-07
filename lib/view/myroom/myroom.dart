import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/guestbook/guestbook.dart';
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
  var selectedIndex = 0;
}

// 마이룸 기본 페이지
class MyRoomPage extends StatelessWidget {
  const MyRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var selectedIndex = context.watch<MyRoomState>().selectedIndex;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = RenderPage();
        break;
      case 1:
        page = InventoryPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return SafeArea(
      child: Expanded(child: mainArea),
    );
  }
}
