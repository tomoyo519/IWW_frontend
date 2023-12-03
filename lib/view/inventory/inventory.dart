import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    var userInfo = context.watch<UserInfo>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MyRoomViewModel(userInfo.userId, RoomRepository())),
      ],
      child: InventoryView(),
    );
  }
}

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  void onePetOneBgAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삐빅! 문제가 발생했어요'),
          content: Text('펫과 배경은 하나만 선택할 수 있습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 다이얼로그 닫기
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var myRoomViewModel = context.watch<MyRoomViewModel>();
    LOG.log('인벤토리 왔니?');

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg/bg17.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: myRoomViewModel.inventory.length,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () async {
                      var itemId = myRoomViewModel.inventory[idx].id;
                      var itemType = myRoomViewModel.inventory[idx].itemType;
                      if (myRoomViewModel.roomObjects
                          .map((e) => e.id)
                          .contains(itemId)) {
                        myRoomViewModel.removeItemFromMyRoom(itemId);
                      } else {
                        bool result = await myRoomViewModel.addItemToMyRoom(
                            itemId, itemType);
                        if (!result) {
                          // ignore: use_build_context_synchronously
                          onePetOneBgAlert(context);
                        }
                      }

                    },
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      color: myRoomViewModel.roomObjects
                              .map((e) => e.id)
                              .contains(myRoomViewModel.inventory[idx].id)
                          ? Colors.deepOrange
                          : Colors.white,
                      child: Card(
                          child: Column(
                        children: [
                          Text(myRoomViewModel.inventory[idx].name),
                          Image.asset(
                            'assets/thumbnail/${myRoomViewModel.inventory[idx].path!.split('.')[0]}.png',
                            fit: BoxFit.cover,
                            height: 80,
                          )
                        ],
                      )),
                    ),
                  );
                })),
      ),
    );
  }
}
