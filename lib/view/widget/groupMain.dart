import 'package:flutter/material.dart';
import 'package:iww_frontend/view/widget/bottombar.dart';

import 'groupList.dart';

class MyGroup extends StatelessWidget {
  const MyGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.groups_outlined)),
              Tab(icon: Icon(Icons.manage_search_outlined))
            ]),
          ),
          body: const TabBarView(children: [GroupList(), Text("야호2")]),
          bottomNavigationBar: MyBottomNav(),
        ));
  }
}
