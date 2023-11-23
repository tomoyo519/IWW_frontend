import 'package:flutter/material.dart';
import 'package:iww_frontend/view/widget/appbar.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'label-list-modal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final List<String> labels = [
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
  GroupDetail({this.group, super.key});
  final group;

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  List<dynamic> groupRoutine = [];
  List<dynamic> groupMems = [];
  late TextEditingController _controller;
  getData() async {
    print(widget.group);
    var result = await http.get(Uri.parse(
        'http://yousayrun.store:8088/group/${widget.group["grp_id"]}'));

    var resultJson = jsonDecode(result.body);

    if (result.body.isNotEmpty) {
      setState(() {
        groupRoutine = resultJson["rout_detail"];
      });

      setState(() => groupMems = resultJson["grp_mems"]);
    }
  }

  joinGroup(grp_id) async {
    // TODO - user_id 수정하기.
    var data = jsonEncode({
      "user_id": "6",
      "grp_id": grp_id.toString(),
    });

    var result = await http
        .post(Uri.parse('http://yousayrun.store:8088/group/${grp_id}/join/6'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: data)
        .catchError((err) {
      print(err);
      return null;
    });

    print(result.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print(widget.group["grp_desc"]);
    _controller = TextEditingController(text: widget.group["grp_decs"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Container(
            margin: EdgeInsets.all(10),
            // padding: EdgeInsets.all(10),

            child: Column(children: [
              Text(
                widget.group["grp_name"],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Divider(color: Colors.grey, thickness: 1, indent: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (c) {
                            return LabelListModal(
                              content: "label",
                              setLabel: (newLabel) {
                                Provider.of<TodoViewModel>(context,
                                        listen: false)
                                    .setSelectedLabel(newLabel);
                              },
                            );
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      alignment: Alignment.center,
                      // TODO - 수정되어야 함.
                      child: Text("카테고리"),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "우리 그룹에 대한 설명이에요",
                  contentPadding: EdgeInsets.symmetric(vertical: 30),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
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
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.black26, width: 1)),
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                      onChanged: null,
                                      value: false,
                                    ),
                                    Text(groupRoutine[i]["rout_name"]),
                                    Icon(Icons.groups_outlined)
                                  ]),
                            )
                          : Text("비었음");
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
                      print('groupMems[index]:${groupMems[index]}');
                      return Column(
                        children: [
                          groupMems.isNotEmpty
                              ? Container(
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
                                      groupMems[index]["user_name"] != null
                                          ? Text(groupMems[index]["user_name"])
                                          : Text("정다희"),
                                    ],
                                  ))
                              : Text("텅")
                        ],
                      );
                    },
                  ),
                ),
              ),
              Divider(color: Colors.grey, thickness: 1, indent: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF3A00E5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () {
                    joinGroup(widget.group["grp_id"]);
                  },
                  child: Text("참가하기", style: TextStyle(color: Colors.white)),
                ),
              )
            ])));
  }
}
