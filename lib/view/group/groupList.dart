import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/repository/group.repository.dart';
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

                        String picturePath = 'assets/category/기타.png';
                        switch (myGroups[i].catName) {
                          case "전체":
                            picturePath = 'assets/category/기타.png';
                            break;

                          case "요가":
                            picturePath = 'assets/category/요가.png';
                            break;

                          case "공부":
                            picturePath = 'assets/category/공부.png';
                            break;

                          case "운동":
                            picturePath = 'assets/category/운동.png';
                            break;

                          case "코딩":
                            picturePath = 'assets/category/코딩.png';
                            break;

                          case "게임":
                            picturePath = 'assets/category/게임.png';
                            break;

                          case "명상":
                            picturePath = 'assets/category/명상.png';
                            break;

                          case "모임":
                            picturePath = 'assets/category/모임.png';
                            break;

                          case "학업":
                            picturePath = 'assets/category/학업.png';
                            break;

                          case "자유시간":
                            picturePath = 'assets/category/자유시간.png';
                            break;

                          case "자기관리":
                            picturePath = 'assets/category/자기관리.png';
                            break;

                          case "독서":
                            picturePath = 'assets/category/독서.png';
                            break;

                          case "여행":
                            picturePath = 'assets/category/여행.png';
                            break;

                          case "유튜브":
                            picturePath = 'assets/category/유튜브.png';
                            break;

                          case "약속":
                            picturePath = 'assets/category/약속.png';
                            break;

                          case "산책":
                            picturePath = 'assets/category/산책.png';
                            break;

                          case "집안일":
                            picturePath = 'assets/category/집안일.png';
                            break;

                          case "취미":
                            picturePath = 'assets/category/취미.png';
                            break;

                          case "기타":
                            picturePath = 'assets/category/기타.png';
                            break;
                          default:
                            picturePath = 'assets/category/기타.png';
                            break;
                        }
                        return TextButton(
                            onPressed: () {
                              var userInfo = context.read<UserInfo>();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiProvider(
                                    // ==== 종속성 주입 ==== //
                                    providers: [
                                      ChangeNotifierProvider.value(
                                          value: context.read<UserInfo>()),
                                      ChangeNotifierProvider.value(
                                          value:
                                              context.read<MyGroupViewModel>()),
                                      ChangeNotifierProvider(
                                        create: (_) => GroupDetailModel(
                                            Provider.of<GroupRepository>(
                                                context,
                                                listen: false),
                                            userInfo.userId),
                                      )
                                    ],
                                    child: GroupDetail(
                                      getList: getList,
                                      group: myGroups[i],
                                    ),
                                  ),
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
                                      picturePath,
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
              : Expanded(
                  child: Lottie.asset('assets/empty.json',
                      repeat: true,
                      animate: true,
                      height: MediaQuery.of(context).size.height * 0.3),
                )
    ]);
  }
}
