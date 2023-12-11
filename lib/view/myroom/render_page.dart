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
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

// 마이홈 주요 구성 (펫, 배경, 하단 버튼)
class RenderPage extends StatelessWidget {
  const RenderPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 배경, 가구 렌더링
          const RoomArea(),
          // 펫 렌더링
          const PetArea(),
          // 상단 상태바
          Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.01,
              child: StatusBar()),
        ],
      ),
    );
  }
}

class PetArea extends StatelessWidget {
  const PetArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final myRoomState = context.read<MyRoomViewModel>();

    return FutureBuilder<int>(
        future:
            myRoomState.fetchMyRoom(), // NOTE 내부에서 notifyListeners() 호출하면 무한루프
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(); // 로딩 중 빈칸
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            LOG.log(
                '########## PetArea 시작 !!!!!!!!!!!: user_id: snapshot.data');

            // roomObject에만 반응하도록 Selector 사용
            return Selector<MyRoomViewModel, List<Item>>(
                selector: (_, myRoomViewModel) => myRoomViewModel.roomObjects,
                builder: (_, roomObjects, __) {
                  return Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.01 - 30,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: MyPet(),
                  );
                });
          }
        });
  }
}

// 방 렌더링
class RoomArea extends StatefulWidget {
  const RoomArea({super.key});

  @override
  State<RoomArea> createState() => _RoomAreaState();
}

class _RoomAreaState extends State<RoomArea> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      context.read<MyRoomViewModel>().fetchInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    LOG.log('############## RoomArea 시작 !!!!!!!!!!!!!!!!!!!!!!');
    final myRoomState = context.watch<MyRoomViewModel>();

    // Naviator를 통해서 argument를 전달할 경우 받는 방법
    // try {
    //   roomState.roomOwner = ModalRoute.of(context)!.settings.arguments as int;
    // } catch (e) {
    //   print("[log/myroom]: $e");
    // }

    /* 1/3 step: 배경 지정 */
    return Stack(children: [
      // Background Image
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 상단 배경
          Expanded(
            flex: 2,
            child: Image.asset('assets/bg/top_01.png', fit: BoxFit.cover),
          ),
          // 하단 배경
          Expanded(
              flex: 1,
              child: Image.asset('assets/bg/bottom_01.png', fit: BoxFit.fill)),
        ],
      ),
      // Room Objects
      TopObjects(
        myRoomState: myRoomState,
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

// 오브젝트 배치
class TopObjects extends StatelessWidget {
  const TopObjects({super.key, required this.myRoomState});

  final myRoomState;

  @override
  Widget build(BuildContext context) {
    final areaWidth = MediaQuery.of(context).size.width;
    final areaHeight = MediaQuery.of(context).size.height;

    return Stack(
        children: myRoomState.roomObjects
            .map((Item item) {
              // 가구가 아니면 렌더링하지 않음.
              if (item.itemType != 2) {
                return SizedBox();
              }

              // [x, y] 형태로 상대좌표 획득
              List<double> position = item.metadata!
                  .split('x')
                  .map((e) => double.parse(e))
                  .toList();
              double x = (areaWidth / 2) * position[0];
              double y = (areaHeight / 2) * position[1];

              // double imageWidth = MediaQuery.of(context).size.width * 0.2;

              return Center(
                child: Transform.translate(
                  // offset을 이동해서 정 중앙 기준으로 이동
                  offset: Offset(x, y),
                  child: SizedBox(
                    width: areaWidth,
                    height: areaWidth,
                    child: Image.asset(
                      'assets/furniture/${item.path}',
                      fit: BoxFit.none,
                    ),
                  ),
                ),
              );
            })
            .toList()
            .cast<Widget>());
  }
}

Future<ui.Image> loadImage(String imagePath) async {
  // 이미지 파일을 읽기 위해 경로에서 바이트 데이터를 가져옴
  final ByteData data = await rootBundle.load(imagePath);
  // 읽어온 바이트 데이터를 Uint8List로 변환
  final Uint8List bytes = data.buffer.asUint8List();
  // 이미지 데이터로 디코딩하여 이미지 객체 생성
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}

void getImageSize(String imagePath) async {
  final ui.Image image = await loadImage(imagePath);
  print('Image width: ${image.width}');
  print('Image height: ${image.height}');
}

// 펫의 체력, 경험치 표시
class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    var userInfo = context.watch<UserInfo>();
    // int totalExp = int.parse(userInfo.itemName!.split('_')[1]) * 1000;
    Item petStatus = context.read<MyRoomViewModel>().getPetItem();

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
            userInfo.mainPetName ?? "메인 펫 이름이 비어있어요",
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
                  value: (petStatus.petExp! / petStatus.totalExp!),
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
                  '${userInfo.petExp} / ${petStatus.totalExp}',
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
