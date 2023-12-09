import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'groupDetail.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/model/group/group.model.dart';

class GroupSearch extends StatefulWidget {
  const GroupSearch({super.key});

  @override
  State<GroupSearch> createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  var labelNum = 0;
  String keyword = "";
  List<Group>? groupList = [];
  List<GroupCategory>? categories;
  bool isClicked = false;
  bool isLoading = true;

  getList() async {
    LOG.log('왜되됫던ㄱ-[ 아ㅣㄴ되냐고 시부레]');
    final userInfo = context.read<UserInfo>();
    // final viewModel = context.watch<MyGroupViewModel>();
    final groupRepository =
        Provider.of<GroupRepository>(context, listen: false);
    LOG.log(
        'userid, ${userInfo.userId} ,labelNum: $labelNum, keyword: $keyword');
    var tempList = await groupRepository.getAllGroupList(
        userInfo.userId, labelNum, keyword);
    LOG.log('thisistmepLIst:$tempList');
    // List<GroupCategory>
    // TODO: 카테고리 정보
    // await RemoteDataSource.get('/category').then((res) {
    //   if (res.statusCode == 200) {
    //     List<dynamic> jsonList = jsonDecode(res.body);
    //     categories = jsonList.map((e) => GroupCategory.fromJson(e)).toList();
    //     isLoading = false;
    //   }
    // });
    setState(() {
      groupList = tempList;
    });
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  List<ChangeNotifierProvider> _groupDetailProviders(BuildContext context) {
    var userInfo = context.read<UserInfo>();
    return [
      ChangeNotifierProvider.value(value: context.read<UserInfo>()),
      ChangeNotifierProvider.value(value: context.read<MyGroupViewModel>()),
      ChangeNotifierProvider(
        create: (_) => GroupDetailModel(
            Provider.of<GroupRepository>(context, listen: false),
            userInfo.userId),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    LOG.log(labelNum.toString());
    return Container(
      child: Column(children: [
        Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: SearchBar(
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                  getList();
                },
                elevation: MaterialStateProperty.all(0),
                onSubmitted: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  getList();
                },
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 226, 225, 225)),
                // backgroundColor: Color(Colors.grey),
                hintText: "키워드 검색",
                leading: Icon(Icons.search_outlined))),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 35,
                margin: EdgeInsets.all(1),
                padding: EdgeInsets.all(1),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: LabelListModal.labels.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: labelNum == index
                              ? Colors.orange
                              : Colors.transparent, //회색으로, 그 외의 버튼은 흰색으로 변경
                          padding: EdgeInsets.all(2), // 패딩을 조절
                          elevation: 0, shape: StadiumBorder(), // 모서리를 완전히 둥글게
                        ),
                        onPressed: () {
                          setState(() {
                            labelNum = index;
                          });
                          getList();
                        },
                        child: Text(
                          LabelListModal.labels[index],
                          style: TextStyle(
                            color: labelNum == index
                                ? Colors.white
                                : Colors.black, // 클릭된 버튼의 배경색을 회색 글자색을 흰색으로 변경
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        isLoading
            ? Expanded(
                child: Lottie.asset('assets/spinner.json',
                    repeat: true,
                    animate: true,
                    height: MediaQuery.of(context).size.height * 0.3),
              )
            : groupList != null && groupList!.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: groupList!.length,
                        itemBuilder: (c, i) {
                          String picturePath = 'assets/category/etc.jpg';
                          switch (groupList![i].catName) {
                            case "전체":
                              picturePath = 'assets/category/etc.jpg';
                              break;

                            case "요가":
                              picturePath = 'assets/category/yoga.jpg';
                              break;

                            case "공부":
                              picturePath = 'assets/category/study.jpg';
                              break;

                            case "운동":
                              picturePath = 'assets/category/exercise.jpg';
                              break;

                            case "코딩":
                              picturePath = 'assets/category/coding.jpg';
                              break;

                            case "게임":
                              picturePath = 'assets/category/game.jpg';
                              break;

                            case "명상":
                              picturePath = 'assets/category/meditation.jpg';
                              break;

                            case "모임":
                              picturePath = 'assets/category/group.jpg';
                              break;

                            case "학업":
                              picturePath = 'assets/category/academy.jpg';
                              break;

                            case "자유시간":
                              picturePath = 'assets/category/freetime.jpg';
                              break;

                            case "자기관리":
                              picturePath = 'assets/category/selfcontrol.jpg';
                              break;

                            case "독서":
                              picturePath = 'assets/category/reading.jpg';
                              break;

                            case "여행":
                              picturePath = 'assets/category/travel.jpg';
                              break;

                            case "유튜브":
                              picturePath = 'assets/category/youtube.jpg';
                              break;

                            case "약속":
                              picturePath = 'assets/category/appointment.jpg';
                              break;

                            case "산책":
                              picturePath = 'assets/category/walking.jpg';
                              break;

                            case "집안일":
                              picturePath = 'assets/category/housework.jpg';
                              break;

                            case "취미":
                              picturePath = 'assets/category/hobby.jpg';
                              break;

                            case "기타":
                              picturePath = 'assets/category/etc.jpg';
                              break;
                            default:
                              picturePath = 'assets/category/etc.jpg';
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
                                            value: context
                                                .read<MyGroupViewModel>()),
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
                                        groupId: groupList![i].groupId,
                                        ownerName: groupList![i].ownerName,
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
                                //     borderRadius: BorderRadius.circular(12),
                                //     border: Border.all(
                                //         color: Colors.black26, width: 1)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          20), // 원하는 border-radius 값으로 변경
                                      child: Image.asset(
                                        picturePath,
                                        fit: BoxFit
                                            .cover, // 이미지의 비율을 유지하면서 가능한 한 많은 공간을 차지하도록 합니다.
                                        width: 85,
                                        height: 85,
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
                                              groupList![i].grpName,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              groupList![i].grpDesc ??
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
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      '${groupList![i].catName}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                    ' 멤버 ${groupList![i].memCnt}명',
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
                    child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/empty.json',
                              repeat: true,
                              animate: true,
                              height: MediaQuery.of(context).size.height * 0.3),
                          Text(
                            "원하는 조건의 그룹이 없어요! \n 다른 키워드, 카테고리로 검색하거나 그룹을 만들 수 있어요.",
                            textAlign: TextAlign.center,
                          )
                        ]),
                  ))
      ]),
    );
  }
}
