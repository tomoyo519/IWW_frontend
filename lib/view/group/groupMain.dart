import 'package:flutter/material.dart';

import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/utils/logger.dart';

import 'package:iww_frontend/view/group/groupList.dart';
import 'package:iww_frontend/view/group/groupSearch.dart';
import 'package:iww_frontend/view/group/newGroup.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

// ==== 종속성 주입을 위한 페이지 위젯 ==== //
class MyGroupPage extends StatelessWidget {
  const MyGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // UserInfo _userInfo = Provider.of<UserInfo>(context, listen: false);
    var userInfo = context.read<UserInfo>();
    final groupRepository = Provider.of<GroupRepository>(
      context,
      listen: false,
    );
    // final _authService = Provider.of<AuthService>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => MyGroupViewModel(groupRepository, userInfo.userId),
      child: MyGroup(groupRepository: groupRepository),
    );
  }
}

// ==== 페이지 내용 ==== //
class MyGroup extends StatefulWidget {
  final GroupRepository groupRepository;
  const MyGroup({
    Key? key,
    required this.groupRepository,
  }) : super(key: key);

  @override
  _MyGroupState createState() => _MyGroupState();
}

class _MyGroupState extends State<MyGroup> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // 효과음 재생 코드
        final assetsAudioPlayer = AssetsAudioPlayer();
        assetsAudioPlayer.open(Audio("assets/main.mp3"));
        assetsAudioPlayer.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userInfo = context.read<UserInfo>();
    Size screen = MediaQuery.of(context).size;
    double fs = screen.width * 0.01;

    return Container(
      width: screen.width,
      height: screen.height,
      padding: EdgeInsets.only(
          // top: 3 * fs,
          // left: 3 * fs,
          // right: 3 * fs,
          ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelStyle: TextStyle(
                fontSize: 20,
                fontFamily: AppTheme.font,
              ),
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const <Widget>[
                Tab(text: "내 그룹"),
                Tab(text: "그룹 찾기"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                        value: context.read<MyGroupViewModel>(),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => GroupDetailModel(
                            widget.groupRepository, userInfo.userId),
                      ),
                    ],
                    child: Stack(children: [
                      GroupList(),
                      // ==== Group Create Floating Button ==== //
                      Positioned(
                        right: 2 * fs,
                        bottom: 5 * fs,
                        child: IconButton(
                          onPressed: () async {
                            var userInfo = context.read<UserInfo>();

                            final assetsAudioPlayer = AssetsAudioPlayer();

                            assetsAudioPlayer.open(
                              Audio("assets/main.mp3"),
                            );

                            assetsAudioPlayer.play();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider.value(
                                        value: context.read<UserInfo>()),
                                    ChangeNotifierProvider(
                                      create: (_) => GroupDetailModel(
                                          Provider.of<GroupRepository>(context,
                                              listen: false),
                                          userInfo.userId),
                                    ),
                                    ChangeNotifierProvider.value(
                                        value:
                                            context.read<MyGroupViewModel>()),
                                    // ChangeNotifierProvider.value(
                                    //     value: context.read<UserInfo>())
                                  ],
                                  child: NewGroup(),
                                ),

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
                            elevation: 8.0,
                            backgroundColor: AppTheme.tertiary,
                            shadowColor: Colors.black45,
                          ),
                          icon: Icon(
                            size: 10 * fs,
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
      ),
    );
  }
}
