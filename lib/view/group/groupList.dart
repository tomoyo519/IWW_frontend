import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
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
  List<Group> groups = [];
  bool isClicked = false;
  getList() async {
    UserInfo userInfo = Provider.of<UserInfo>(context, listen: false);
    int userId = userInfo.user_id;

    var result = await RemoteDataSource.get('/group/$userId/groups');
    if (result.statusCode == 200) {
      var jsonData = jsonDecode(result.body);

      var response = jsonData['result'];
      LOG.log('response: $response');
      if (mounted) {
        setState(() {
          List<dynamic> result = jsonData['result'];
          groups = result.map((e) => Group.fromJson(e)).toList();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<MyGroupViewModel>();
    final myGroups = viewModel.groups;
    LOG.log('thiismygroups:, ${myGroups}');
    return Column(children: [
      groups.isNotEmpty
          ? Expanded(
              child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (c, i) {
                    print(groups[i]);
                    return TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, "/group/detail",
                            arguments: groups[i]),

                        //   {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) =>
                        //             GroupDetail(group: groups[i])));
                        // },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.black26, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start, //
                                children: [
                                  Text(
                                    groups[i].grpName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    groups[i].grpDesc ?? "그룹에 대한 설명입니다.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    ' ${groups[i].catName}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              Text('멤버 ${groups[i].memCnt}명',
                                  style: TextStyle(fontSize: 13))
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
