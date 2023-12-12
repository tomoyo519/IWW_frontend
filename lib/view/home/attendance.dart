import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/user/attendance.model.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';

class Attendance extends StatelessWidget {
  // late UserInfo userInfo;
  final List<String> attDays;
  Attendance({super.key, required this.attDays});

  @override
  Widget build(BuildContext context) {
    double fs = MediaQuery.of(context).size.width * 0.01;
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 3 * fs),
              child: Text(
                "출석 체크",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 5 * fs,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Wrap(
                    // spacing: -22.0, // 각 자식 사이의 수평 간격. 음수로 설정하면 자식들이 겹치게 됩니다.
                    children: List<Widget>.generate(7, (index) {
                      return attDays.contains(index.toString())
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green, // 버튼 배경색을 초록색으로 설정
                                shape: CircleBorder(),
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white, // 아이콘 색상
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
                          : TextButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                shape: CircleBorder(),
                              ),
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
                                style: TextStyle(
                                  color: Colors.black,
                                ),
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
