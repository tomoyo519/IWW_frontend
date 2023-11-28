import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'groupList.dart';
import 'groupSearch.dart';
import 'newGroup.dart';

class MyGroup extends StatelessWidget {
  const MyGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final _groupRepository =
        Provider.of<GroupRepository>(context, listen: false);
    final _authService = Provider.of<AuthService>(context, listen: false);

    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: MyAppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {},
                color: (Colors.black),
              )
            ],
          ),
          // AppBar(
          //   bottom: TabBar(tabs: const [
          //     Tab(icon: Icon(Icons.groups_outlined)),
          //     Tab(icon: Icon(Icons.manage_search_outlined))
          //   ]),
          // ),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.groups_outlined)),
                    Tab(icon: Icon(Icons.manage_search_outlined)),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (context) =>
                              MyGroupViewModel(_groupRepository, _authService),
                        ),
                        ChangeNotifierProvider(
                          create: (context) =>
                              GroupDetailModel(_groupRepository),
                        ),
                      ],
                      child: GroupList(),
                    ),
                    GroupSearch(),
                  ]),
                ),
              ],
            ),
          ),
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
