import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/routine/routine.model.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/group/groupImg.model.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'dart:convert';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/group/groupMain.dart';
import 'package:iww_frontend/view/todo/todo_editor.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';

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
  final getList;
  GroupDetail({required this.getList, required this.group, super.key});

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
  List<GroupImg>? routineImgs;

  getData() async {
    var result = await RemoteDataSource.get('/group/${widget.group.groupId}');
    var resultJson = jsonDecode(result.body);

    if (result.statusCode == 200) {
      setState(() {
        List<dynamic> jsonRoutList = resultJson["result"]["rout_detail"];
        groupRoutine = jsonRoutList
            .map((e) => Routine.fromGroupDetailJson(e, widget.group.groupId))
            .toList();

        groupMems = resultJson["result"]["grp_mems"];
        isLoading = false;
      });

      for (var i = 0; i < groupMems.length; i++) {
        final userId = context.read<UserInfo>().userId;
        if (groupMems[i]["user_id"] == userId) {
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
    final userId = context.read<UserInfo>().userId;
    var data = jsonEncode({
      "user_id": userId,
      "grp_id": grp_id,
    });

    await RemoteDataSource.post("/group/$grp_id/join/${userId}", body: data)
        .then((res) async {
      if (res.statusCode == 201) {
        final viewModel = context.read<MyGroupViewModel>();
        await viewModel.fetchMyGroupList(userId);
        if (context.mounted) {
          await widget.getList();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: const Text("그룹 가입이 완료 되었어요!")));
          Navigator.pop(context);
        }
      }
    });
  }

  exitGroup(grp_id) async {
    final userId = context.read<UserInfo>().userId;
    var data = jsonEncode({
      "user_id": userId,
      "grp_id": grp_id,
    });
    await RemoteDataSource.delete("/group/$grp_id/left/${userId}", body: data)
        .then(
      (result) async {
        LOG.log("${result.body}, ${result.statusCode}");
        if (result.statusCode == 200) {
          final viewModel = context.read<MyGroupViewModel>();
          await viewModel.fetchMyGroupList(userId);
          if (context.mounted) {
            await widget.getList();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: const Text("그룹 탈퇴가 완료 되었어요!")));
            Navigator.pop(context);
          }
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text("그룹 탈퇴 실패했어요. 재시도 해주세요.")));
          Navigator.pop(context);
        }
      },
    );
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
    final userInfo = context.read<UserInfo>();
    final groupmodel = context.read<MyGroupViewModel>();
    Todo? todo = routine?.generateTodo(userInfo.userId);

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
            onSave: (context) => _updateRoutine(context),
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    );
  }

  void _setRoutinePicture(int rout_id) async {
    var result = await RemoteDataSource.get(
            "/group/${widget.group.groupId}/user/${rout_id}/image")
        .then((res) {
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        LOG.log(res.body);
        setState(() {
          routineImgs = (json["result"] as List)
              .map((item) => GroupImg.fromJson(item))
              .toList();
        });
      }
      LOG.log('thisisroutineImgs: ${routineImgs}');
    });
    // 클릭시, 그룹 구성원의 사진 인증 보여주는 기능
    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              routineImgs!.isNotEmpty
                  ? Container(
                      child: Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 각 행에 3개의 그리드 항목이 표시됩니다.
                          childAspectRatio: 1.0, // 그리드 항목의 가로세로 비율을 1:1로 설정합니다.
                        ),
                        itemCount: routineImgs?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.15, // 높이를 줄입니다.
                                  width: MediaQuery.of(context).size.width *
                                      0.3, // 너비를 줄입니다.
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(2),
                                  child: Image.network(
                                    '${Secrets.REMOTE_SERVER_URL}/group-image/' +
                                        routineImgs![index].todoImg,
                                    fit: BoxFit
                                        .cover, // 이미지가 부모 위젯의 크기에 맞게 조절되도록 합니다.
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ))
                  : Expanded(
                      child: Lottie.asset('assets/empty.json',
                          repeat: true,
                          animate: true,
                          height: MediaQuery.of(context).size.height * 0.3)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppNavigator nav = context.read<AppNavigator>();
    return !isLoading
        ? Scaffold(
            appBar: MyAppBar(),
            body: Container(
                // padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      widget.group.grpName,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                // Divider(color: Colors.grey, thickness: 1, indent: 10),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "카테고리 ",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // 스타일 설정 추가
                            backgroundColor: Colors.orange, // 버튼 배경색을 오렌지색으로 설정
                          ),
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            alignment: Alignment.center,
                            child: Text(
                              widget.group.catName ?? "카테고리 미확인",
                              style: TextStyle(
                                  color: Colors.white), // 글자색을 흰색으로 설정
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {},
                //       child: Container(
                //           width: MediaQuery.of(context).size.width * 0.15,
                //           alignment: Alignment.center,
                //           // TODO - 수정되어야 함.
                //           child: Text(widget.group.catName ?? "카테고리")),
                //     ),
                //   ],
                // ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "그룹 세부 정보",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    readOnly: true,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "우리 그룹에 대한 설명이에요",
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                    ),
                  ),
                ),

                Divider(
                  thickness: 10,
                  height: 30,
                ),

                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "기본 루틴",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupRoutine.length,
                        itemBuilder: (c, i) {
                          return groupRoutine.isNotEmpty
                              ? GestureDetector(
                                  onLongPress: () {
                                    _showTodoEditor(context, groupRoutine[i]);
                                  },
                                  onTap: () {
                                    _setRoutinePicture(groupRoutine[i].routId);
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
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              "참가자",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // 스타일 설정 추가
                          backgroundColor: Colors.orange, // 버튼 배경색을 오렌지색으로 설정
                        ),
                        onPressed: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          alignment: Alignment.center,
                          child: Text(
                            widget.group.memCnt.toString() + '명',
                            style:
                                TextStyle(color: Colors.white), // 글자색을 흰색으로 설정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: Container(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2 / 1, crossAxisCount: 3),
                        itemCount: groupMems.isEmpty ? 0 : groupMems.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              nav.push(AppRoute.room, argument: groupMems[index]["user_id"].toString());
                            },
                            child :Column(
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (!myGroup) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF3A00E5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onPressed: () async {
                          await joinGroup(widget.group.groupId);
                        },
                        child:
                            Text("참가하기", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ],
                if (myGroup) ...[
                  Divider(color: Colors.grey, thickness: 1, indent: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF3A00E5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onPressed: () async {
                          await exitGroup(widget.group.groupId);
                        },
                        child:
                            Text("탈퇴하기", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ]
              ]),
            )))
        : Lottie.asset('assets/spinner.json',
            repeat: true,
            animate: true,
            height: MediaQuery.of(context).size.height * 0.3);
  }
}
