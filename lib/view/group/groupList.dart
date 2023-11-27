import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'groupDetail.dart';
import 'newGroup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
import 'package:lottie/lottie.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<dynamic> groups = [];

  getList() async {
    print('찍히긴 하고요?');
    // TODO - user_id 변경해야해
    var result = await RemoteDataSource.get('/group/1/groups');
    if (result.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(result.body);
      setState(() {
        List<dynamic> result = jsonData['result'];
        LOG.log('thisisgroups:P{:::::::::::$result');
        groups = result;
      });
    }
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
                      child: Lottie.asset('assets/spinner.json',
                          repeat: true,
                          animate: true,
                          height: MediaQuery.of(context).size.height * 0.3),
                    );
            }),
      ),
    ]);
  }
}
