import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/routine/routine.model.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'dart:convert';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/todo/todo_editor.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

final List<String> labels = [
  '전체',
  '운동',
  '식단',
  '회사업무',
  '가족행사',
  '저녁약속',
  '청첩장모임',
  '루틴',
  '개발공부'
];

class GroupDetail extends StatefulWidget {
  final Group group;
  GroupDetail({required this.group, super.key});

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  List<Routine> groupRoutine = [];
  List<dynamic> groupMems = [];
  bool myGroup = false;
  bool isLoading = true;
  late TextEditingController _controller;
  late GlobalKey<FormState> _formKey;

  getData() async {
    var result = await RemoteDataSource.get('/group/${widget.group.groupId}');
    var resultJson = jsonDecode(result.body);

    if (result.statusCode == 200) {
      setState(() {
        // Group, Routine Type 맞춰서 수정
        List<dynamic> jsonRoutList = resultJson["result"]["rout_detail"];

        LOG.log(resultJson["result"]["rout_detail"]);
        groupRoutine = jsonRoutList
            .map((e) => Routine.fromGroupDetailJson(e, widget.group.groupId))
            .toList();

        groupMems = resultJson["result"]["grp_mems"];
        isLoading = false;
      });

      for (var i = 0; i < groupMems.length; i++) {
        if (groupMems[i]["user_id"] == 1) {
          setState(() {
            myGroup = true;
          });
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  joinGroup(grp_id) async {
    // TODO - user_id 수정하기.
    var data = jsonEncode({
      "user_id": 1,
      "grp_id": grp_id,
    });
    var result =
        await RemoteDataSource.post("/group/${grp_id}/join/1", body: data);
    if (result.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("그룹 가입이 완료 되었어요!")));

      Navigator.pushNamed(context, "/group");
    }
  }

  exitGroup(grp_id) async {
    //탈퇴하기;
    // TODO - user_id 수정하기.
    var data = jsonEncode({
      "user_id": 1,
      "grp_id": grp_id,
    });
    var result =
        await RemoteDataSource.delete("/group/${grp_id}/left/${1}", body: data);
    LOG.log(result.body);
    if (result.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("그룹 탈퇴가 완료 되었어요!")));
      Navigator.pushNamed(context, "/group");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("그룹 탈퇴 실패했어요. 재시도 해주세요.")));
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();

    _controller = TextEditingController(text: widget.group.grpDesc);
    _formKey = GlobalKey<FormState>();
  }

  // TODO: 루틴 수정 시
  void _updateRoutine(BuildContext context) {
    final viewmodel = context.read<EditorModalViewModel>();

    LOG.log("Not implemented. ${viewmodel.hour}");
    Navigator.pop(context);
  }

  // 할일 수정
  void _showTodoEditor(BuildContext context, Routine? routine) {
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    final groupmodel = context.read<MyGroupViewModel>();
    Todo? todo = routine?.generateTodo(userInfo.user_id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => EditorModalViewModel(
            of: todo,
            user: userInfo,
            parent: groupmodel,
          ),
          child: EditorModal(
            init: todo,
            title: "루틴 수정",
            formKey: _formKey,
            onSave: (context) => _updateRoutine(context),
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            appBar: MyAppBar(),
            body: Container(
                margin: EdgeInsets.all(10),
                child: Column(children: [
                  Text(
                    widget.group.grpName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Divider(color: Colors.grey, thickness: 1, indent: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            alignment: Alignment.center,
                            // TODO - 수정되어야 함.
                            child: Text(widget.group.catName ?? "카테고리")),
                      ),
                    ],
                  ),
                  TextField(
                    readOnly: true,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "우리 그룹에 대한 설명이에요",
                      contentPadding: EdgeInsets.symmetric(vertical: 30),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "기본 루틴",
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                  Divider(color: Colors.grey, thickness: 1, indent: 10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: groupRoutine.length,
                        itemBuilder: (c, i) {
                          return groupRoutine.isNotEmpty
                              ? GestureDetector(
                                  onLongPress: () {
                                    _showTodoEditor(context, groupRoutine[i]);
                                  },
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      useRootNavigator: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.8,
                                          child: Column(
                                            // TODO - 사진추가
                                            children: [Text('사용자 사진이 보여지는 화면')],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  // ==== Group Routine ==== //
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.black26, width: 1)),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Checkbox(
                                            onChanged: null,
                                            value: false,
                                          ),
                                          Text(groupRoutine[i].routName),
                                          Icon(Icons.groups_outlined)
                                        ]),
                                  ),
                                )
                              : Text("조회된 그룹이 없습니다.");
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "참가자",
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                  Divider(color: Colors.grey, thickness: 1, indent: 10),
                  Expanded(
                    child: Container(
                      height: 200,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2 / 1, crossAxisCount: 3),
                        itemCount: groupMems.isEmpty ? 0 : groupMems.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.orangeAccent,
                                          width: 5)),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.account_circle_rounded),
                                      Text(groupMems[index]["user_name"] ?? "")
                                    ],
                                  ))
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  if (!myGroup) ...[
                    Divider(color: Colors.grey, thickness: 1, indent: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF3A00E5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onPressed: () {
                          joinGroup(widget.group.groupId);
                        },
                        child:
                            Text("참가하기", style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                  if (myGroup) ...[
                    Divider(color: Colors.grey, thickness: 1, indent: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF3A00E5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onPressed: () {
                          exitGroup(widget.group.groupId);
                        },
                        child:
                            Text("탈퇴하기", style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ]
                ])))
        : Lottie.asset('assets/spinner.json',
            repeat: true,
            animate: true,
            height: MediaQuery.of(context).size.height * 0.3);
  }
}
