import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';

import 'groupList.dart';
import 'groupSearch.dart';
import 'newGroup.dart';

class MyGroup extends StatelessWidget {
  const MyGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: const [
              Tab(icon: Icon(Icons.groups_outlined)),
              Tab(icon: Icon(Icons.manage_search_outlined))
            ]),
          ),
          body: const TabBarView(children: [GroupList(), GroupSearch()]),
          bottomNavigationBar: MyBottomNav(),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => NewGroup()));
              },
              child: Icon(Icons.add)),
        ));
  }
}
