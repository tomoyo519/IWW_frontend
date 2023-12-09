import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/user/attendance.model.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late UserInfo userInfo;

  List attDays = [];
  List days = ["일", "월", "화", "수", "목", "금", "토"];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getList();
    });
  }

  getList() async {
    userInfo = context.read<UserInfo>();
    await RemoteDataSource.get('/attendance/${userInfo.userId}').then((res) {
      LOG.log(res.body);
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);

        for (int i = 0; i < json.length; i++) {
          LOG.log('${json["result"][i]["day_of_week"]}');
          setState(() {
            attDays.add(json["result"][i]["day_of_week"].toString());
          });
        }
        LOG.log('thisisdays; $attDays');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    Text("출석 체크"),
                  ],
                ),
                Center(
                  child: Wrap(
                    spacing: -22.0, // 각 자식 사이의 수평 간격. 음수로 설정하면 자식들이 겹치게 됩니다.
                    children: List<Widget>.generate(7, (index) {
                      return attDays.contains(index.toString())
                          ? ElevatedButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.check,
                                color: Colors.white, // 아이콘 색상
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green, // 버튼 배경색을 초록색으로 설정
                                shape: CircleBorder(),
                              ),
                            )
                          // Container(
                          //     padding:
                          //         EdgeInsets.all(10.0), // 아이콘과 배경 사이의 간격 조정
                          //     decoration: BoxDecoration(
                          //       color: Colors.blue, // 배경색
                          //       shape: BoxShape.circle, // 원형 배경
                          //     ),
                          //     child:
                          //   )
                          : ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                index == 0
                                    ? "일"
                                    : index == 1
                                        ? "월"
                                        : index == 2
                                            ? "화"
                                            : index == 3
                                                ? "수"
                                                : index == 4
                                                    ? "목"
                                                    : index == 5
                                                        ? "금"
                                                        : "토",
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                              ),
                            );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
