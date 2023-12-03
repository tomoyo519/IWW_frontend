import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/utils/login_wrapper.dart';
import 'package:iww_frontend/view/group/groupDetail.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:lottie/lottie.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<Group> groups = [];
  bool isClicked = false;
  getList() async {
    UserInfo userInfo = Provider.of<UserInfo>(context, listen: false);
    int userId = userInfo.userId;

    var result = await RemoteDataSource.get('/group/$userId/groups');
    if (result.statusCode == 200) {
      var jsonData = jsonDecode(result.body);

      var response = jsonData['result'];
      LOG.log('response: $response');
      if (mounted) {
        setState(() {
          List<dynamic> result = jsonData['result'];
          groups = result.map((e) => Group.fromJson(e)).toList();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MyGroupViewModel>();
    final myGroups = viewModel.groups;
    LOG.log('${viewModel.waiting}');
    return Column(children: [
      viewModel.waiting
          ? Expanded(
              child: Container(
                child: Lottie.asset('assets/spinner.json',
                    repeat: true,
                    animate: true,
                    height: MediaQuery.of(context).size.height * 0.3),
              ),
            )
          : myGroups.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: myGroups.length,
                      itemBuilder: (c, i) {
                        LOG.log('mygroups:::::::::::::${myGroups[i]}');
                        // Color bgColor;
                        // switch (myGroups[i].catName) {
                        //   case '코딩':
                        //     bgColor = Colors.red;
                        //     break;
                        //   case '학업':
                        //     bgColor = Colors.green;
                        //     break;
                        //   default:
                        //     bgColor = Colors.white;
                        //     break;
                        // }
                        return TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoginWrapper(
                                      child: MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider.value(
                                        value: context.read<MyGroupViewModel>(),
                                      ),
                                      ChangeNotifierProvider(
                                        create: (_) => GroupDetailModel(
                                          Provider.of<GroupRepository>(context,
                                              listen: false),
                                        ),
                                      )
                                    ],
                                    child: GroupDetail(
                                      group: myGroups[i],
                                    ),
                                  )),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              // decoration: BoxDecoration(
                              // color: bgColor,
                              // borderRadius: BorderRadius.circular(12),
                              // border: Border.all(
                              //     color: Colors.black26, width: 1)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10), // 원하는 border-radius 값으로 변경
                                    child: Image.asset(
                                      'assets/profile.png',
                                      width: 65,
                                      height: 65,
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10), // 필요에 따라 이미지와 텍스트 사이의 간격을 조절하세요
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            myGroups[i].grpName,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            myGroups[i].grpDesc ??
                                                "그룹에 대한 설명입니다.",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical:
                                                        2), // Container 위젯의 padding 속성 사용
                                                alignment: Alignment
                                                    .center, // Container 위젯의 alignment 속성 사용
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '${myGroups[i].catName}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(' 멤버 ${myGroups[i].memCnt}명',
                                                  style:
                                                      TextStyle(fontSize: 13))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }),
                )
              : Lottie.asset('assets/empty.json',
                  repeat: true,
                  animate: true,
                  height: MediaQuery.of(context).size.height * 0.3),
    ]);
  }
}
