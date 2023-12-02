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

class GroupSearch extends StatefulWidget {
  const GroupSearch({super.key});

  @override
  State<GroupSearch> createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  var labelNum = 1;
  String keyword = "";
  List<Group>? groupList = [];

  getList() async {
    // final viewModel = context.watch<MyGroupViewModel>();
    final groupRepository =
        Provider.of<GroupRepository>(context, listen: false);

    var tempList = await groupRepository.getAllGroupList(1, labelNum, keyword);

    setState(() {
      groupList = tempList;
    });
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
                                backgroundColor: Colors.grey, // 배경색을 회색으로 변경
                                padding: EdgeInsets.all(2), // 패딩을 조절

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
                                  color: Colors.white, // 글자색을 흰색으로 변경
                                ),
                              )));
                    },
                  )),
            ),
          ],
        ),
        groupList!.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: groupList?.length,
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
                                        value: context.read<MyGroupViewModel>())
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
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.black26, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, //
                                  children: [
                                    Text(
                                      groupList?[i].grpName ?? "그룹 이름",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      groupList?[i].grpDesc ?? "그룹에 대한 설명입니다.",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      ' ${groupList?[i].catName}',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Text('멤버 ${groupList?[i].memCnt}명',
                                    style: TextStyle(fontSize: 13))
                              ],
                            ),
                          ));
                    }),
              )
            : Lottie.asset('assets/spinner.json',
                repeat: true,
                animate: true,
                height: MediaQuery.of(context).size.height * 0.3)
      ]),
    );
  }
}
