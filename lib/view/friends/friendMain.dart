import 'package:flutter/material.dart';
import 'package:iww_frontend/view/friends/friendList.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'friendRank.dart';


class MyFriend extends StatelessWidget {
  const MyFriend({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserInfo>().userId;

    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: const [
              Tab(icon: Icon(Icons.group)),
              Tab(icon: Icon(Icons.leaderboard))
            ]),
          ),
          body: TabBarView(children: [FriendList(userId: userId), FriendRank()]),
        ));
  }
}
