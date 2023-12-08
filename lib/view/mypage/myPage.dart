import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/mypage/announcement.dart';
import 'package:iww_frontend/view/mypage/myInfoEdit.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/model/mypage/reward.model.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/view/mypage/slider.dart';

class MyPage extends StatefulWidget {
  MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Rewards>? rewards;
  bool isLoading = true;
  @override
  void initState() {
    LOG.log('야호?');
    // TODO: implement initState
    super.initState();
    getRewards();
  }

  getRewards() async {
    LOG.log('여보세요 나야');
    final userId = context.read<UserInfo>().userId;
    var result =
        await RemoteDataSource.get('/achievements/${userId}').then((res) {
      if (res.statusCode == 200) {
        LOG.log(res.body);

        var json = jsonDecode(res.body);
        List<Rewards> result = (json["result"] as List)
            .map((item) => Rewards.fromJson(item))
            .toList();
        setState(() {
          rewards = result;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = context.watch<UserInfo>();
    LOG.log('thisisname:${userInfo.userName}');
    String formattedNumber = userInfo.userTel.substring(0, 3) +
        '-' +
        userInfo.userTel.substring(3, 7) +
        '-' +
        userInfo.userTel.substring(7, 11);
    return SingleChildScrollView(
      child: Center(
        child: Flexible(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/profile.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    userInfo.userName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 4.0),
                                  child: Text(
                                    formattedNumber,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    25), // border-radius 설정
                              ),
                              child: TextButton(
                                child: Text(
                                  "프로필 관리",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () async {
                                  bool? isChanged =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (c) =>
                                          ChangeNotifierProvider.value(
                                        value: context.read<UserInfo>(),
                                        child: MyInfoEdit(
                                            userName: userInfo.userName),
                                      ),
                                    ),
                                  );

                                  LOG.log(emoji: 2, '바뀌었나요? $isChanged');

                                  if (isChanged != null && isChanged == true) {
                                    await userInfo.fetchUser();
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0), // 내부 패딩을 0으로 설정
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Lottie.asset("assets/money.json",
                          animate: true, repeat: false, width: 50, height: 50),
                      Text(
                        "보유 캐시",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        userInfo.userHp.toString() + '원',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Lottie.asset("assets/star.json",
                          animate: true, repeat: false, width: 50, height: 50),
                      Text(
                        "경험치",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        userInfo.userHp.toString() + 'P',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "내 업적 현황",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  if (isLoading == true) ...[
                    Lottie.asset('assets/spinner.json',
                        repeat: true,
                        animate: true,
                        height: MediaQuery.of(context).size.height * 0.3),
                  ],
                  if (rewards != null && rewards!.isNotEmpty) ...[
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Expanded(
                          child: GridView.builder(
                              itemCount: rewards!.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, childAspectRatio: 1.0),
                              itemBuilder: (context, index) {
                                return Card(
                                    child: Column(children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: Image.asset('assets/medal.png',
                                              fit: BoxFit.scaleDown),
                                        ),
                                        Text(
                                          (rewards != null &&
                                                  rewards![index].achiName !=
                                                      null)
                                              ? rewards![index]
                                                  .achiName
                                                  .toString()
                                              : '업적',
                                        ),
                                      ],
                                    ),
                                  )
                                ]));
                              }),
                        ))
                  ],
                  if (rewards != null && rewards!.isEmpty) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(child: Text("획득한 뱃지가 없어요!")),
                      ),
                    )
                  ]
                ],
              ),
            ),
            Divider(
              thickness: 10,
            ),
            // CarouselSliderDemo(),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5.0), // 오른쪽에만 패딩 적용
                      child: Icon(Icons.campaign_outlined),
                    ),
                    TextButton(
                      child:
                          Text("공지사항", style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (c) => ChangeNotifierProvider.value(
                              value: context.read<UserInfo>(),
                              child: Announcement(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Icon(Icons.info_outline),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("앱 관리 버전",
                                style: TextStyle(color: Colors.black)),
                            Text("V1.0.0",
                                style: TextStyle(color: Colors.black))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Icon(Icons.logout_outlined),
                    ),
                    TextButton(
                      onPressed: () async {
                        await context.read<AuthService>().logout();
                      },
                      child:
                          Text("로그아웃하기", style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Icon(Icons.exit_to_app_outlined),
                    ),
                    TextButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext c) {
                              final authService = context.read<AuthService>();
                              return AlertDialog(
                                title: Text('정말 탈퇴하시겠어요?'),
                                content: Text('탈퇴 후 재가입 할 수 없습니다 그래도 탈퇴하시겠어요?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('탈퇴하기'),
                                    onPressed: () async {
                                      final userId =
                                          context.read<UserInfo>().userId;
                                      await RemoteDataSource.delete(
                                              '/user/${userId}')
                                          .then(
                                        (res) {
                                          if (res.statusCode == 200) {
                                            Navigator.pop(context);
                                            authService.status =
                                                AuthStatus.failed;
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  TextButton(
                                    child: Text('닫기'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 모달 닫기
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child:
                          Text("탈퇴하기", style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
