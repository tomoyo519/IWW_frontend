import 'package:flutter/material.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/model/item/item.model.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

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
    var userInfo = context.read<UserInfo>();

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg/bg17.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: myRoomViewModel.inventory.length,
                  itemBuilder: (context, idx) {
                    return GestureDetector(
                      onTap: () async {
                        // 아이템 터치 -> 선택 or 선택 해제
                        Item i = myRoomViewModel.inventory[idx];
                        myRoomViewModel.toggleItem(i);
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
                  }),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5,
            bottom: MediaQuery.of(context).size.height * 0.1,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                  myRoomViewModel.applyChanges();
                // myRoomState.toggleGrowth();
                userInfo.fetchUser();
              },
              child: Text('적용하기'),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
