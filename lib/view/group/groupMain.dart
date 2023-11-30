import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/view/group/groupList.dart';
import 'package:iww_frontend/view/group/groupSearch.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';

class MyGroup extends StatelessWidget {
  const MyGroup({super.key});

  @override
  Widget build(BuildContext context) {
    // UserInfo _userInfo = Provider.of<UserInfo>(context, listen: false);
    final groupRepository = Provider.of<GroupRepository>(
      context,
      listen: false,
    );
    // final _authService = Provider.of<AuthService>(context, listen: false);

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: const <Widget>[
                Tab(icon: Icon(Icons.groups_outlined)),
                Tab(icon: Icon(Icons.manage_search_outlined)),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => MyGroupViewModel(
                        groupRepository,
                      ),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => GroupDetailModel(
                        groupRepository,
                      ),
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
      // bottomNavigationBar: MainPage(),
      //   floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (c) => MultiProvider(
      //             providers: [
      //               Provider(
      //                 create: (context) =>
      //                     Provider.of<UserInfo>(context, listen: false),
      //               ),
      //               ChangeNotifierProvider(
      //                   create: (context) =>
      //                       MyGroupViewModel(_groupRepository, _userInfo)),
      //             ],
      //             child: LoginWrapper(child: NewGroup()),
      //           ),
      //         ),
      //       );
      //     },
      //     child: Icon(Icons.add),
      //   ),
      // ),
    );
  }
}
