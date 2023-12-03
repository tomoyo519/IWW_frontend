import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/utils/login_wrapper.dart';
import 'package:iww_frontend/view/group/groupList.dart';
import 'package:iww_frontend/view/group/groupSearch.dart';
import 'package:iww_frontend/view/group/newGroup.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';

// ==== 종속성 주입을 위한 페이지 위젯 ==== //
class MyGroupPage extends StatelessWidget {
  const MyGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // UserInfo _userInfo = Provider.of<UserInfo>(context, listen: false);
    final groupRepository = Provider.of<GroupRepository>(
      context,
      listen: false,
    );
    // final _authService = Provider.of<AuthService>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => MyGroupViewModel(groupRepository),
      child: MyGroup(groupRepository: groupRepository),
    );
  }
}

// ==== 페이지 내용 ==== //
class MyGroup extends StatelessWidget {
  const MyGroup({
    super.key,
    required this.groupRepository,
  });

  final GroupRepository groupRepository;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black, // 글자색을 검정색으로 설정
              indicatorColor: Colors.black,

              tabs: const <Widget>[
                Tab(text: "내 그룹"),
                Tab(text: "그룹 검색하기"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                        value: context.read<MyGroupViewModel>(),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => GroupDetailModel(
                          groupRepository,
                        ),
                      ),
                    ],
                    child: Stack(children: [
                      GroupList(),
                      // ==== Group Create Floating Button ==== //
                      Positioned(
                        right: 10,
                        bottom: 15,
                        child: IconButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => LoginWrapper(
                                        child: ChangeNotifierProvider.value(
                                            value: context
                                                .read<MyGroupViewModel>(),
                                            child: NewGroup()),
                                      )

                                  // MultiProvider(
                                  //   providers: [
                                  //     // Provider(
                                  //     //   create: (context) =>
                                  //     //       Provider.of<UserInfo>(context,
                                  //     //           listen: false),
                                  //     // ),
                                  //     // ChangeNotifierProvider(
                                  //     //   create: (context) =>
                                  //     //       Provider.of<MyGroupViewModel>(
                                  //     //           context,
                                  //     //           listen: false),
                                  //     // ),
                                  //     ChangeNotifierProvider.value(
                                  //       value: context.read<MyGroupViewModel>(),
                                  //     )
                                  //   ],
                                  //   child: LoginWrapper(child: NewGroup()),
                                  ),
                            );
                            // if (context.mounted &&
                            //     result != null &&
                            //     result == true) {
                            //   await context
                            //       .read<MyGroupViewModel>()
                            //       .fetchMyGroupList();
                            // }
                          },
                          style: IconButton.styleFrom(
                            elevation: 1,
                            backgroundColor: Colors.orange,
                            shadowColor: Colors.black45,
                          ),
                          icon: Icon(
                            size: 30,
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  GroupSearch(),
                ],
              ),
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
