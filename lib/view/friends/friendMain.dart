import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';

import 'friendList.dart';
import 'friendRank.dart';

class MyFriend extends StatelessWidget {
  const MyFriend({super.key});

  @override
  Widget build(BuildContext context) {
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
          body: TabBarView(children: [FriendList(), FriendRank()]),
          bottomNavigationBar: MyBottomNav(),
        ));
  }
}
