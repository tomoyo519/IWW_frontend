import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/utils/login_wrapper.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'groupDetail.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';

class GroupSearch extends StatefulWidget {
  const GroupSearch({super.key});

  @override
  State<GroupSearch> createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  var labelNum = 0;
  String keyword = "";
  List<Group>? groupList = [];
  bool isClicked = false;
  bool isLoading = true;

  getList() async {
    final userInfo = context.read<UserInfo>();
    // final viewModel = context.watch<MyGroupViewModel>();
    final groupRepository =
        Provider.of<GroupRepository>(context, listen: false);

    var tempList = await groupRepository.getAllGroupList(
        userInfo.userId ?? 1, labelNum + 1, keyword);
    LOG.log('thisistmepLIst:$tempList');
    setState(() {
      groupList = tempList;
    });
    isLoading = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
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
                },
                elevation: MaterialStateProperty.all(0),
                onSubmitted: (value) {
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
                                    : Colors
                                        .transparent, //회색으로, 그 외의 버튼은 흰색으로 변경
                                padding: EdgeInsets.all(2), // 패딩을 조절
                                elevation: 0,
                                shape: StadiumBorder(), // 모서리를 완전히 둥글게
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
                                      : Colors
                                          .black, // 클릭된 버튼의 배경색을 회색 글자색을 흰색으로 변경
                                ),
                              )));
                    },
                  )),
            ),
          ],
        ),
        isLoading
            ? Expanded(
                child: Container(
                  child: Lottie.asset('assets/spinner.json',
                      repeat: true,
                      animate: true,
                      height: MediaQuery.of(context).size.height * 0.3),
                ),
              )
            : (groupList ?? []).isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: groupList?.length ?? 0,
                        itemBuilder: (c, i) {
                          return TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginWrapper(
                                        child: MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                            create: (_) => GroupDetailModel(
                                                Provider.of<GroupRepository>(
                                                    context,
                                                    listen: false))),
                                        ChangeNotifierProvider.value(
                                            value: context
                                                .read<MyGroupViewModel>())
                                      ],
                                      child: GroupDetail(
                                        group: groupList![i],
                                      ),
                                    )),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
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
                : Lottie.asset('assets/empty.json',
                    repeat: true,
                    animate: true,
                    height: MediaQuery.of(context).size.height * 0.3),
      ]),
    );
  }
}
