import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/friends/friendMain.dart';
import 'package:iww_frontend/view/guestbook/guestbook.dart';
import 'package:iww_frontend/view/myroom/mypet.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

// 마이홈 주요 구성 (펫, 배경, 하단 버튼)
class RenderPage extends StatelessWidget {
  const RenderPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var myRoomState = context.read<MyRoomViewModel>();

    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 배경, 가구 렌더링
          RenderMyRoom(),
          // 펫 렌더링
          FutureBuilder<int>(
              future: UserRepository().getUserHealth(myRoomState.getRoomOwner),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int health = snapshot.data!; // snapshot.data에서 비동기 작업 결과를 받아옴

                  return Selector<MyRoomViewModel, List<Item>>(
                      selector: (_, myRoomViewModel) =>
                          myRoomViewModel.roomObjects,
                      builder: (_, roomObjects, __) {
                        return Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: MyPet(
                              newSrc: myRoomState.findPetName(),
                              isDead: health == 0),
                        );
                      });
                }
              }),
          // 상단 상태바
          Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.01,
              child: StatusBar()),
          // 하단 버튼
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: kBottomNavigationBarHeight +
          //       MediaQuery.of(context).size.height * 0.14,
          //   height: 50,
          //   child: BottomButtons(),
          // ),
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
    // var roomState = context.watch<MyRoomViewModel>();

    // Naviator를 통해서 argument를 전달할 경우 받는 방법
    // try {
    //   roomState.roomOwner = ModalRoute.of(context)!.settings.arguments as int;
    // } catch (e) {
    //   print("[log/myroom]: $e");
    // }

    /* 1/3 step: 배경 지정 */
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 상단 배경
        Expanded(
          flex: 2,
          child: Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg/top_01.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TopObjects(),
            ),
          ),
        ),
        // 하단 배경
        Expanded(
            flex: 1,
            child: Container(
                child:
                    Image.asset('assets/bg/bottom_01.png', fit: BoxFit.fill))),
      ],
    );

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

// 상단 배경 부분을 차지하는 컨테이너
class TopObjects extends StatelessWidget {
  const TopObjects({super.key});

  @override
  Widget build(BuildContext context) {
    var roomState = context.watch<MyRoomViewModel>();

    return Stack(
        children: roomState.roomObjects.map((Item item) {
      // 가구가 아니면 렌더링하지 않음.
      if (item.itemType != 2) {
        return SizedBox();
      }

      List<double> position =
          item.metadata!.split('x').map((e) => double.parse(e)).toList();
      double x = position[0];
      double y = position[1];

      // double imageWidth = MediaQuery.of(context).size.width * 0.2;

      return Positioned(
        top: MediaQuery.of(context).size.height * y,
        left: MediaQuery.of(context).size.width * x,
        // width: imageWidth,
        // height: imageWidth,
        child: Image.asset(
          'assets/furniture/${item.path}',
          fit: BoxFit.none,
        ),
      );
    }).toList());
  }
}

// 펫의 체력, 경험치 표시
class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    var userInfo = context.read<UserInfo>();
    // int totalExp = int.parse(userInfo.itemName!.split('_')[1]) * 1000;
    int totalExp = 1000;
    String petName = context.read<MyRoomViewModel>().findPetNickName();

    return Container(
      height: 100,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            petName,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  '체력',
                  style: TextStyle(
                    fontSize: 18,
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
          Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  '경험치 ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: LinearProgressIndicator(
                  value: (userInfo.petExp ?? 0) / totalExp,
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
    var roomState = context.read<MyRoomViewModel>();
    final user = Provider.of<UserInfo>(context, listen: false);

    // 인벤토리 <-> 마이홈 버튼
    ElevatedButton buildInventoryButton() {
      if (roomState.isMyRoom()) {
        return ElevatedButton(
            onPressed: () {
              // myRoomState.toggleGrowth();
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
