import 'package:flutter/material.dart';
import 'package:iww_frontend/groupDetail.dart';
import 'groupDetail.dart';

class GroupList extends StatelessWidget {
  const GroupList({super.key});
  final List<dynamic> groups = const [
    {"grp_name": "Flutter study (최소1시간)", "grp_member": "30/100"},
    {"grp_name": "매주 토요일 등산하기", "grp_member": "17/100"},
    {"grp_name": "매주 도커 컨테이너 하나 배포하기", "grp_member": "99/100"},
    {"grp_name": "Flutter study (최소1시간)", "grp_member": "30/100"},
    {"grp_name": "Flutter study (최소1시간)", "grp_member": "30/100"},
    {"grp_name": "매주 토요일 등산하기", "grp_member": "17/100"},
    {"grp_name": "매주 도커 컨테이너 하나 배포하기", "grp_member": "99/100"},
    {"grp_name": "Flutter study (최소1시간)", "grp_member": "30/100"},
    {"grp_name": "Flutter study (최소1시간)", "grp_member": "30/100"},
    {"grp_name": "매주 토요일 등산하기", "grp_member": "17/100"},
    {"grp_name": "매주 도커 컨테이너 하나 배포하기", "grp_member": "99/100"},
    {"grp_name": "Flutter study (최소1시간)", "grp_member": "30/100"}
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                      Text(groups[i]["grp_name"]),
                      Text(groups[i]["grp_member"])
                    ],
                  ),
                ));
          }),
    );
  }
}
