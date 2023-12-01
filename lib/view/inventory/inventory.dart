import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:iww_frontend/secrets/secrets.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    var userInfo = context.watch<UserInfo>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MyRoomViewModel(userInfo.user_id, RoomRepository())),
      ],
      child: InventoryView(),
    );
  }
}

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    var myRoomViewModel = context.watch<MyRoomViewModel>();
    LOG.log('${Secrets.REMOTE_SERVER_URL}/image/원숭이.png');

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg/bg7.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: myRoomViewModel.items.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                        child: Column(
                      children: [
                        Text(myRoomViewModel.items[idx].name),
                        Image.network(
                          '${Secrets.REMOTE_SERVER_URL}/image/${myRoomViewModel.items[idx].image}',
                          fit: BoxFit.cover,
                        )
                      ],
                    )),
                  );
                })),
      ),
    );
  }
}
