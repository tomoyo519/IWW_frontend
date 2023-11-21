import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/view/widget/groupDetail.dart';
import 'newGroup.dart';
import 'package:http/http.dart' as http;

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<dynamic> groups = const [];

  getList() async {
    var result = await http
        .get(Uri.parse('http://yousayrun.store:8088/todo'))
        .catchError((err) {
      print(err);
      return null;
    });
    groups = jsonDecode(result.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (c, i) {
              return TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => GroupDetail(group: groups[i])));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          groups[i]["grp_name"],
                          style: TextStyle(color: Colors.black),
                        ),
                        Text('${groups[i]["mem_cnt"]}/100',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800))
                      ],
                    ),
                  ));
            }),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => NewGroup()));
          },
          child: Text("새로운 그룹 만들기", style: TextStyle(color: Colors.white)),
        ),
      )
    ]);
  }
}
