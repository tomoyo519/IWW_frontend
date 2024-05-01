import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/friends/friendMain.dart';
import 'package:iww_frontend/view/guestbook/guestbook.dart';
import 'package:iww_frontend/view/inventory/newinventory.dart';
import 'package:iww_frontend/view/test/test.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/view/myroom/render_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

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

    return MultiProvider(providers: [
      ChangeNotifierProvider<CommentsProvider>(
          create: (_) => CommentsProvider(
                userId.toString(),
                roomOwner.toString(),
                commentRepository,
              )),
      ChangeNotifierProvider<MyRoomViewModel>(create: (_) {
        var viewModel = MyRoomViewModel(userId, roomRepository, roomOwner);
        if (roomOwner != userId) {
          viewModel.fetchFriendStatus();
        }
        return viewModel;
      }),
    ], child: MyRoomPage());
  }
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
      case 3:
        // return FontTestPage();
        return MyFriend();
      default:
        return Center(
            child: SizedBox(
                height: 300, width: 300, child: Text('페이지를 찾을 수 없습니다.')));
    }
  }

  SpeedDial buildSpeedDial() {
    var myRoomViewModel = Provider.of<MyRoomViewModel>(context);
    int userId = myRoomViewModel.getUserId;
    int ownerId = myRoomViewModel.getRoomOwner;
    FriendRepository friendRepository = FriendRepository();

    SpeedDialChild friendStatusChild;
    switch (myRoomViewModel.friendStatus) {
      case 0: // 내 방일 때
        friendStatusChild = SpeedDialChild(
          shape: CircleBorder(),
          child: Icon(
            Icons.group,
            color: Colors.black,
          ),
          labelWidget: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "친구목록",
              style: TextStyle(color: Colors.black),
            ),
          ),
          // label: '친구목록',
          onTap: () async {
            setState(() {
              _selectedIndex = 3;
            });
            final assetsAudioPlayer = AssetsAudioPlayer();
            assetsAudioPlayer.open(Audio("assets/main.mp3"));
            assetsAudioPlayer.play();
          },
        );
        break;
      case 1: // 친구 상태
        friendStatusChild = SpeedDialChild(
          shape: CircleBorder(),
          child: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          labelWidget: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "친구입니다.",
              style: TextStyle(color: Colors.black),
            ),
          ),
          // label: '친구목록',
          onTap: () {},
        );
        break;
      case 2:
        friendStatusChild = SpeedDialChild(
          shape: CircleBorder(),
          child: Icon(
            Icons.hourglass_empty,
            color: Colors.black,
          ),
          labelWidget: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "친구 요청 중입니다.",
              style: TextStyle(color: Colors.black),
            ),
          ),
          // label: '친구목록',
          onTap: () {},
        );
        break;
      case 3:
        friendStatusChild = SpeedDialChild(
          shape: CircleBorder(),
          child: Icon(
            Icons.check,
            color: Colors.black,
          ),
          labelWidget: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "친구 수락",
              style: TextStyle(color: Colors.black),
            ),
          ),
          // label: '친구목록',
          onTap: () async {
            setState(() {
              myRoomViewModel.friendStatus = 1; // myRoomViewModel 인스턴스 사용
            });
            await friendRepository.createFriend(userId, ownerId);
            var data = {'senderId': userId, 'receiverId': ownerId};
            EventService.sendEvent("friendResponse", data);
          },
        );
        break;
      case 4: // 아무 상태도 아님
        // friendStatusChild = SpeedDialChild(
        //   child: Icon(Icons.person_add, color: Colors.black),
        //   labelWidget: Text("친구 요청"),
        //   onTap: () async {
        //     // 친구 요청 보내기 로직
        //     // 요청 후 상태 업데이트 필요
        //     setState(() {
        //       myRoomViewModel.friendStatus = 2; // 요청 보낸 상태로 업데이트
        //     });
        //   },
        // );
        friendStatusChild = SpeedDialChild(
          shape: CircleBorder(),
          child: Icon(
            Icons.person_add,
            color: Colors.black,
          ),
          labelWidget: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "친구 요청",
              style: TextStyle(color: Colors.black),
            ),
          ),
          // label: '친구목록',
          onTap: () {
            setState(() {
              myRoomViewModel.friendStatus = 2; // myRoomViewModel 인스턴스 사용
            });
            friendRepository.createFriend(userId, ownerId);
            var data = {'senderId': userId, 'receiverId': ownerId};
            EventService.sendEvent("friendRequest", data);
          },
        );
        break;
      default:
        friendStatusChild = SpeedDialChild(
          shape: CircleBorder(),
          child: Icon(
            Icons.group,
            color: Colors.black,
          ),
          labelWidget: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "친구목록",
              style: TextStyle(color: Colors.black),
            ),
          ),
          // label: '친구목록',
          onTap: () async {
            setState(() {
              _selectedIndex = 3;
            });
            final assetsAudioPlayer = AssetsAudioPlayer();
            assetsAudioPlayer.open(Audio("assets/main.mp3"));
            assetsAudioPlayer.play();
          },
        );
    }

    return SpeedDial(
      overlayOpacity: 0.0,
      animatedIcon: AnimatedIcons.view_list,
      onOpen: () async {
        final assetsAudioPlayer = AssetsAudioPlayer();
        assetsAudioPlayer.open(Audio("assets/main.mp3"));
        assetsAudioPlayer.play();
      },
      onClose: () async {
        final assetsAudioPlayer = AssetsAudioPlayer();
        assetsAudioPlayer.open(Audio("assets/main.mp3"));
        assetsAudioPlayer.play();
      },
      children: [
        SpeedDialChild(
          elevation: 0.0,
          labelWidget: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "마이홈",
              style: TextStyle(color: Colors.black),
            ),
          ),
          shape: CircleBorder(),
          child: CircleAvatar(
            // 원형 아이콘
            backgroundColor: Colors.white,
            child: Icon(
              Icons.home,
              color: Colors.black,
            ),
          ),
          // label: '마이홈',
          // labelBackgroundColor: Colors.green, // 투

          onTap: () async {
            setState(() {
              _selectedIndex = 0;
            });
            final assetsAudioPlayer = AssetsAudioPlayer();
            assetsAudioPlayer.open(Audio("assets/main.mp3"));
            assetsAudioPlayer.play();
          },
        ),
        if (myRoomViewModel.isMyRoom())
          SpeedDialChild(
            shape: CircleBorder(),
            labelWidget: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "인벤토리",
                style: TextStyle(color: Colors.black),
              ),
            ),
            onTap: () async {
              final assetsAudioPlayer = AssetsAudioPlayer();
              assetsAudioPlayer.open(Audio("assets/main.mp3"));
              assetsAudioPlayer.play();
              return _showInventorySheet();
            },
            child: CircleAvatar(
              backgroundColor: (Colors.white),
              child: Icon(
                Icons.work_rounded,
                color: Colors.black,
              ),
            )
          ),
        SpeedDialChild(
          labelWidget: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "방명록",
              style: TextStyle(color: Colors.black),
            ),
          ),
          shape: CircleBorder(),
          // label: '방명록',
          // onTap: ,
          onTap: () async {
            final assetsAudioPlayer = AssetsAudioPlayer();
            assetsAudioPlayer.open(Audio("assets/main.mp3"));
            assetsAudioPlayer.play();
            return _showComments();
          },

          // child: Icon(Icons.local_post_office),
          child: Icon(
            Icons.comment_rounded,
            color: Colors.black,
          ),
          // label: '방명록',
        ),
        friendStatusChild,
      ],
      child: Icon(Icons.menu),
    );
  }
}
