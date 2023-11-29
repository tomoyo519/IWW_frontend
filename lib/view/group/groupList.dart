import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:provider/provider.dart';
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
    UserInfo userInfo = Provider.of<UserInfo>(context, listen: false);
    int userId = userInfo.user_id;

    var result = await RemoteDataSource.get('/group/$userId/groups');
    if (result.statusCode == 200) {
      var jsonData = jsonDecode(result.body);

      var response = jsonData['results'];
      LOG.log('response: $response');
      setState(() {
        List<dynamic> result = jsonData['results'];
        groups = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      groups.isNotEmpty
          ? Expanded(
              child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (c, i) {
                    return TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) =>
                                      GroupDetail(group: groups[i])));
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
                        ));
                  }),
            )
          : Container(
              child: Lottie.asset('assets/spinner.json',
                  repeat: true,
                  animate: true,
                  height: MediaQuery.of(context).size.height * 0.3),
            ),
    ]);
  }
}
