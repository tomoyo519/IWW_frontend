import 'package:flutter/material.dart';
import 'package:iww_frontend/view/widget/bottombar.dart';

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
          body: const TabBarView(children: [FriendList(), FriendRank()]),
          bottomNavigationBar: MyBottomNav(),
        ));
  }
}
