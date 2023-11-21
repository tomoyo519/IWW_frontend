import 'package:flutter/material.dart';
import 'package:iww_frontend/appbar.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'listWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroupDetail extends StatefulWidget {
  GroupDetail({this.group, super.key});
  final group;
  TextEditingController controller =
      TextEditingController(text: "우리 그룹의 규칙이에요!");

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  List<dynamic> groutRoutine = [];
  List<dynamic> groupMems = [];

  getData() async {
    print(widget.group["grp_id"]);
    var result = await http.get(Uri.parse(
        'http://yousayrun.store:8088/group/${widget.group["grp_id"]}'));

    var resultJson = jsonDecode(result.body);
    if (result.body.isNotEmpty) {
      setState(() {
        groutRoutine = resultJson["rout_detail"];
      });

      setState(() => groupMems = resultJson["grp_mems"]);
    }
  }

  joinGroup() {
    print("api 진행 중");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller =
        TextEditingController(text: widget.group["grp_decs"] ?? "");

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Text(widget.group["grp_name"]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (c) {
                            return LabelList(
                              content: "label",
                              setLabel: (newLabel) {
                                Provider.of<SelectedDate>(context,
                                        listen: false)
                                    .setSelectedDate(newLabel as String);
                              },
                            );
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      alignment: Alignment.center,
                      child: Text("카테고리"),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 60),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                ),
              ),
              Text("기본 루틴"),
              Divider(color: Colors.grey, thickness: 1, indent: 10),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black26, width: 1)),
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                            value: false,
                            onChanged: (c) {
                              //TODO - onclick시 todo 완료 체크 해야함
                            }),
                        // Text(groutRoutine[i]["todo_name"]),
                        // groutRoutine[i]["grp_id"] == null
                        //     ? Icon(Icons.query_builder_outlined)
                        //     : Icon(Icons.groups_outlined)
                      ])),
              Text("참가자"),
              Divider(color: Colors.grey, thickness: 1, indent: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: groupMems.isEmpty ? 0 : groupMems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        groupMems.isNotEmpty
                            ? Text(groupMems[index]["user_name"])
                            : Text("텅")
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF3A00E5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () {
                    joinGroup();
                  },
                  child: Text("참가하기", style: TextStyle(color: Colors.white)),
                ),
              )
            ])));
  }
}
