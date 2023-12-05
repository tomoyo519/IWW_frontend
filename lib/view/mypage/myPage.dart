import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/mypage/announcement.dart';
import 'package:iww_frontend/view/mypage/myInfoEdit.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/model/mypage/reward.model.dart';
import 'package:iww_frontend/secrets/secrets.dart';

class MyPage extends StatefulWidget {
  MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Rewards>? rewards;
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
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (c) =>
                                          ChangeNotifierProvider.value(
                                        value: context.read<UserInfo>(),
                                        child: MyInfoEdit(
                                            userName: userInfo.userName),
                                      ),
                                    ),
                                  );
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
                  if (rewards != null && rewards!.isNotEmpty) ...[
                    Container(
                        child: Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 1.0),
                          itemBuilder: (context, index) {
                            return Card(
                                child: Column(children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Image.asset('/assets/profile.png'),
                                  Text(rewards![index].achiName.toString()),
                                ],
                              )
                                  // Image.network(
                                  // '${Secrets.REMOTE_SERVER_URL}/group-image/' +
                                  //     routineImgs![index].todoImg,
                                  // fit: BoxFit
                                  // .cover, // 이미지가 부모 위젯의 크기에 맞게 조절되도록 합니다.
                                  // ),
                                  )
                            ]));
                          }),
                    ))
                  ]
                ],
              ),
            ),
            Divider(
              thickness: 15,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.0), // 오른쪽에만 패딩 적용
                      child: Icon(Icons.campaign_outlined),
                    ),
                    TextButton(
                      child: Text("공지사항"),
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
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.info_outline),
                    ),
                    Text("앱 관리 버전")
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.logout_outlined),
                    ),
                    TextButton(
                      onPressed: () async {
                        await context.read<AuthService>().logout();
                      },
                      child: Text("로그아웃하기"),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.exit_to_app_outlined),
                    ),
                    Text("탈퇴하기")
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
