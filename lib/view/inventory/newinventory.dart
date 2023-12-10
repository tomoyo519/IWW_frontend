import 'package:flutter/material.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

Widget inventorySheet(BuildContext context, MyRoomViewModel myRoomViewModel,
    VoidCallback onClose) {
  var userInfo = context.read<UserInfo>();
  bool hasChanges = myRoomViewModel.checkForChanges();

  return Stack(
    children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.vertical(bottoom: Radius.circular(20)),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: DefaultTabController(
            length: 2, // 탭의 수
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0),
                  child: TabBar(
                    labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    tabs: const <Widget>[
                      // Tab(child: Row(children: [Icon(Icons.pets), Text('펫')])),
                      // Tab(child: Row(children: [Icon(Icons.inventory), Text('아이템')])),
                      Tab(
                        child: Padding(
                          // 각 Tab의 내부 패딩 조정
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(children: [Icon(Icons.pets), Text('펫')]),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          // 각 Tab의 내부 패딩 조정
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                              children: [Icon(Icons.inventory), Text('아이템')]),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      PetTab(), // PET 탭 구현
                      ItemTab(), // Item 탭 구현
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 170,
        left: 20,
        child: ElevatedButton(
          onPressed: hasChanges
              ? () async {
                  await myRoomViewModel.applyChanges();
                  userInfo.fetchUser();
                  onClose();
                }
              : () {
                  onClose();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: hasChanges ? Colors.blue : Colors.grey[300],
            shape: CircleBorder(),
            padding: EdgeInsets.all(15), // 버튼의 크기 조정
          ),
          child: Icon(
            hasChanges ? Icons.check : Icons.close,
            color: hasChanges ? Colors.white : Colors.grey[800],
          ),
        ),
      ),
    ],
  );
}

class PetTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 펫 탭 구현
    var myRoomViewModel = context.watch<MyRoomViewModel>();
    LOG.log('소유한 펫의 개수 : ${myRoomViewModel.pets.length}');
    // 펫 탭 구현
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: myRoomViewModel.pets.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                Item i = myRoomViewModel.pets[index];
                myRoomViewModel.toggleItem(i);
              },
              child: Container(
                width: 90,
                height: 100, // 각 펫 카드의 너비
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: myRoomViewModel.roomObjects
                          .map((e) => e.id)
                          .contains(myRoomViewModel.pets[index].id)
                      ? Colors.blue[100]
                      : Colors.white,
                  border: myRoomViewModel.roomObjects
                          .map((e) => e.id)
                          .contains(myRoomViewModel.pets[index].id)
                      ? Border.all(color: Colors.blue.shade700, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: myRoomViewModel.roomObjects
                          .map((e) => e.id)
                          .contains(myRoomViewModel.pets[index].id)
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(myRoomViewModel.pets[index].name),
                    // 여기에 펫 이미지, 이름 등을 표시
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/thumbnail/${myRoomViewModel.pets[index].path!}',
                        fit: BoxFit.cover,
                        height: 70,
                      ),
                    ),
                  ],
                ),
              ));
        }); // 펫 탭 내용
  }
}

class ItemTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 아이템 탭 구현
    var myRoomViewModel = context.watch<MyRoomViewModel>();
    LOG.log('소유한 아이템 개수 : ${myRoomViewModel.items.length}');
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: myRoomViewModel.items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                Item i = myRoomViewModel.items[index];
                myRoomViewModel.toggleItem(i);
              },
              child: Container(
                width: 90,
                height: 100, // 각 펫 카드의 너비
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: myRoomViewModel.roomObjects
                          .map((e) => e.id)
                          .contains(myRoomViewModel.items[index].id)
                      ? Colors.blue[100]
                      : Colors.white,
                  border: myRoomViewModel.roomObjects
                          .map((e) => e.id)
                          .contains(myRoomViewModel.items[index].id)
                      ? Border.all(color: Colors.blue.shade700, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: myRoomViewModel.roomObjects
                          .map((e) => e.id)
                          .contains(myRoomViewModel.items[index].id)
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(myRoomViewModel.items[index].name),
                    // 여기에 펫 이미지, 이름 등을 표시
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/thumbnail/${myRoomViewModel.items[index].path!}',
                        fit: BoxFit.cover,
                        height: 70,
                      ),
                    ),
                  ],
                ),
              ));
        }); // 펫 탭 내용/ 아이템 탭 내용
  }
}

// class BackgroundTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // 아이템 탭 구현
//     var myRoomViewModel = context.watch<MyRoomViewModel>();
//     LOG.log('소유한 배경 개수 : ${myRoomViewModel.backgrounds.length}');
//     return ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: myRoomViewModel.backgrounds.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//               onTap: () async {
//                 Item i = myRoomViewModel.backgrounds[index];
//                 myRoomViewModel.toggleItem(i);
//               },
//               child: Container(
//                 width: 90,
//                 height: 100, // 각 펫 카드의 너비
//                 margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                 decoration: BoxDecoration(
//                   color: myRoomViewModel.roomObjects
//                           .map((e) => e.id)
//                           .contains(myRoomViewModel.backgrounds[index].id)
//                       ? Colors.blue[100]
//                       : Colors.white,
//                   border: myRoomViewModel.roomObjects
//                           .map((e) => e.id)
//                           .contains(myRoomViewModel.backgrounds[index].id)
//                       ? Border.all(color: Colors.blue.shade700, width: 2)
//                       : null,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: myRoomViewModel.roomObjects
//                           .map((e) => e.id)
//                           .contains(myRoomViewModel.backgrounds[index].id)
//                       ? [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.5),
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                             offset: Offset(0, 3),
//                           ),
//                         ]
//                       : [],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(myRoomViewModel.items[index].name),
//                     // 여기에 펫 이미지, 이름 등을 표시
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.asset(
//                         'assets/thumbnail/${myRoomViewModel.items[index].path!}',
//                         fit: BoxFit.cover,
//                         height: 70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ));
//         }); // 펫 탭 내용/ 아이템 탭 내용
//   }
// }