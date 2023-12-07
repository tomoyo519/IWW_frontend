import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/friends/friendMain.dart';
import 'package:iww_frontend/view/guestbook/guestbook.dart';
import 'package:iww_frontend/view/myroom/mypet.dart';
import 'package:iww_frontend/view/myroom/myroom.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

// 마이홈 주요 구성 (펫, 배경, 하단 버튼)
class MyRoomComponent extends StatelessWidget {
  const MyRoomComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var myRoomState = context.watch<MyRoomViewModel>();

    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 펫과 배경 등 구조물은 FutureBuilder를 통해 렌더링
                  RenderMyRoom(),
                  // 펫 렌더링
          FutureBuilder<int>(
              future: UserRepository().getUserHealth(myRoomState.getRoomOwner),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int health = snapshot.data!; // snapshot.data에서 비동기 작업 결과를 받아옴

                return Selector<MyRoomViewModel, List<Item>>(
                    selector: (_, myRoomViewModel) =>
                        myRoomViewModel.roomObjects,
                    builder: (_, roomObjects, __) {
                        return MyPet(
                            newSrc: myRoomState.findPetName(),
                            isDead: health == 0);
                      });
                }
              }),
          // 방 렌더링
                  
          // 상단 상태바
          Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.01,
              height: 150,
              child: UnderLayer()),
          // 하단 버튼
          Positioned(
            left: 0,
            right: 0,
            bottom: kBottomNavigationBarHeight +
                MediaQuery.of(context).size.height * 0.14,
            height: 50,
            child: BottomButtons(),
          ),
        ],
      ),
    );
  }
  
}

// 방 렌더링
class RenderMyRoom extends StatelessWidget {
  const RenderMyRoom({super.key});

  @override
  Widget build(BuildContext context) {
    LOG.log('############## RenderMyRoom 시작 !!!!!!!!!!!!!!!!!!!!!!');

    var roomState = context.watch<MyRoomViewModel>();

    // Naviator를 통해서 argument를 전달할 경우 받는 방법
    // try {
    //   roomState.roomOwner = ModalRoute.of(context)!.settings.arguments as int;
    // } catch (e) {
    //   print("[log/myroom]: $e");
    // }

    // 1/3 step: 배경 지정
    return Stack(alignment: Alignment.center, children: [
      // 펫 렌더링

      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: roomState.getBackgroundImage(),
            fit: BoxFit.cover,
          ),
        ),
        child: roomState.renderRoomObjects(
          MediaQuery.of(context).size.height / 6.0,
        ),
      ),
      
    ]);

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

// status bar or chatting(빈칸)
class UnderLayer extends StatelessWidget {
  UnderLayer({Key? key}) : super(key: key);

  // myroom: status bar, other's room: chatting
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + 30,
      color: Colors.transparent,
      child: context.watch<MyRoomViewModel>().isMyRoom()
          ? StatusBar()
          : SizedBox(height: 110, width: 20), // TODO chatting으로 변경
      // BottomButtons()
    );
  }
}

// 펫의 체력, 경험치 표시
class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    var userInfo = context.read<UserInfo>();
    int totalExp = int.parse(userInfo.mainPetName.split('_')[1]) * 1000;

    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    '체력:',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: LinearProgressIndicator(
                    value: userInfo.userHp / 10,
                    minHeight: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 239, 118, 110)),
                    backgroundColor: Colors.grey[200],
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: Text(
                    '${userInfo.userHp} / 10',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    '경험치: ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: LinearProgressIndicator(
                    value: userInfo.petExp / totalExp,
                    minHeight: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 155, 239, 110)),
                    backgroundColor: Colors.grey[200],
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: Text(
                    '${userInfo.petExp} / $totalExp',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
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
    final commentsProvider = context.read<CommentsProvider>();
    // final inventoryState = context.read<InventoryState>();
    final myRoomState = context.read<MyRoomState>();
    var roomState = context.read<MyRoomViewModel>();
    final user = Provider.of<UserInfo>(context, listen: false);

    // 인벤토리 <-> 마이홈 버튼
    ElevatedButton buildInventoryButton() {
      if (roomState.isMyRoom()) {
        return ElevatedButton(
            onPressed: () {
              myRoomState.toggleGrowth();
            },
            child: Text('인벤토리'));
      } else {
        return ElevatedButton(
            onPressed: () {
              roomState.roomOwner = user.userId;
            },
            child: Text('마이홈'));
      }
    }

    // 친구목록 <-> 친구추가 버튼
    ElevatedButton buildFriendButton() {
      if (roomState.isMyRoom()) {
        return ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => ChangeNotifierProvider.value(
                    value: context.read<UserInfo>(),
                    child: MyFriend(),
                  ),
                ),
              );
              
              if (result != null) {
                roomState.roomOwner = result as int;
              }
            },
            child: Text('친구목록'));
      } else {
        return ElevatedButton(
            onPressed: () {
              // TODO 친구추가 기능
            },
            child: Text('친구추가'));
      }
    }

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                commentsProvider.changeOwner(roomState.getRoomOwner.toString());

                if (context.mounted) {
                  showCommentsBottomSheet(context, commentsProvider);
                }
              },
              child: Text('방명록')),
          SizedBox(width: 20),
          buildInventoryButton(),
          SizedBox(width: 20),
          buildFriendButton(),
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
