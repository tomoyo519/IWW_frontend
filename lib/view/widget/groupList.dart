import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/view/widget/groupDetail.dart';
import 'newGroup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<dynamic> groups = [];

  getList() async {
    // TODO - user_id 변경해야해
    var result = await http
        .get(Uri.parse('http://yousayrun.store:8088/group/6/groups'))
        .catchError((err) {
      print(err);
      return null;
    });
    print(result.body);
    setState(() {
      groups = jsonDecode(result.body);
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
    return Column(children: [
      Expanded(
        child: ListView.builder(
            itemCount: groups.isNotEmpty ? groups.length : 1,
            itemBuilder: (c, i) {
              return groups.isNotEmpty
                  ? TextButton(
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
                            border:
                                Border.all(color: Colors.black26, width: 1)),
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
                      ))
                  : Container(
                      child: Text('조회된 그룹이 없습니다.'),
                    );
            }),
      ),
    ]);
  }
}
