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
import 'package:iww_frontend/view/mypage/slider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

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
    String formattedNumber = userInfo.userTel.substring(0, 3) +
        '-' +
        userInfo.userTel.substring(3, 7) +
        '-' +
        userInfo.userTel.substring(7, 11);
    return isLoading
        ? Center(
            child: Lottie.asset('assets/spinner.json',
                repeat: true,
                animate: true,
                height: MediaQuery.of(context).size.height * 0.3),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            userInfo.userName,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 17,
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
                                              fontSize: 17,
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
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () async {
                                          final assetsAudioPlayer =
                                              AssetsAudioPlayer();
                                          assetsAudioPlayer
                                              .open(Audio("assets/main.mp3"));
                                          assetsAudioPlayer.play();
                                          bool? isChanged =
                                              await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (c) =>
                                                  ChangeNotifierProvider.value(
                                                value: context.read<UserInfo>(),
                                                child: MyInfoEdit(
                                                    userName:
                                                        userInfo.userName),
                                              ),
                                            ),
                                          );

                                          if (isChanged != null &&
                                              isChanged == true) {
                                            await userInfo.fetchUser();
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.all(
                                              0), // 내부 패딩을 0으로 설정
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 추가된 부분
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft, // 추가된 부분
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          "내 성취도",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "레벨업 조건",
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        IconButton(
                                            alignment: Alignment.centerLeft,
                                            onPressed: () {},
                                            icon: Icon(Icons
                                                .arrow_forward_ios_outlined),
                                            iconSize: 15.0)
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // 여기에서 원하는 radius 값을 설정합니다.
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      animation: true,
                                      lineHeight: 20.0,
                                      animationDuration: 2500,
                                      percent: userInfo.userHp / 100,
                                      center: Text("${userInfo.userHp} / 100"),
                                      barRadius: Radius.circular(10),
                                      linearStrokeCap: LinearStrokeCap
                                          .butt, // 이 속성을 추가하여 끝 부분이 둥글게 나오지 않도록 합니다.
                                      progressColor: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                          if (rewards != null && rewards!.isEmpty) ...[
                            Column(children: [
                              Lottie.asset('assets/empty.json',
                                  repeat: true,
                                  animate: true,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("업적이 없네요! 할일 수행해서 업적 받아봐요!"),
                                ),
                              )
                            ]),
                          ],

                          if (rewards != null && rewards!.isNotEmpty) ...[
                            Container(
                              color: (Colors.white),
                              padding: EdgeInsets.all(10),
                              child: SingleChildScrollView(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: rewards!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1.0),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Image.asset(
                                                  rewards![index].achiImg!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                (rewards != null)
                                                    ? rewards![index]
                                                        .achiName
                                                        .toString()
                                                    : '업적',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ]

                          // if (rewards != null && rewards!.isEmpty) ...[
                          //   Center(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Expanded(child: Text("획득한 뱃지가 없어요!")),
                          //     ),
                          //   )
                          // ]
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      // width: MediaQuery.of(context).size.width * 0.9,
                      child: CarouselSliderDemo(),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5.0, left: 2), // 오른쪽에만 패딩 적용
                              child: Icon(
                                Icons.campaign_outlined,
                                size: 30,
                              ),
                            ),
                            TextButton(
                              child: Text("공지사항",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
                              onPressed: () async {
                                final assetsAudioPlayer = AssetsAudioPlayer();
                                assetsAudioPlayer
                                    .open(Audio("assets/main.mp3"));
                                assetsAudioPlayer.play();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (c) =>
                                        ChangeNotifierProvider.value(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: 30,
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final assetsAudioPlayer = AssetsAudioPlayer();
                                  assetsAudioPlayer
                                      .open(Audio("assets/main.mp3"));
                                  assetsAudioPlayer.play();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "앱 관리 버전",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                    Text("V1.0.0",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17))
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
                              child: Icon(
                                Icons.logout_outlined,
                                size: 30,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final assetsAudioPlayer = AssetsAudioPlayer();
                                assetsAudioPlayer
                                    .open(Audio("assets/main.mp3"));
                                assetsAudioPlayer.play();
                                await context.read<AuthService>().logout();
                              },
                              child: Text("로그아웃하기",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
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
                              child: Icon(
                                Icons.exit_to_app_outlined,
                                size: 30,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final assetsAudioPlayer = AssetsAudioPlayer();
                                assetsAudioPlayer
                                    .open(Audio("assets/main.mp3"));
                                assetsAudioPlayer.play();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext c) {
                                      final authService =
                                          context.read<AuthService>();
                                      return AlertDialog(
                                        title: Text('정말 탈퇴하시겠어요?'),
                                        content: Text(
                                            '탈퇴 후 재가입 할 수 없습니다 그래도 탈퇴하시겠어요?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('탈퇴하기'),
                                            onPressed: () async {
                                              final userId = context
                                                  .read<UserInfo>()
                                                  .userId;
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
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .pop(); // 모달 닫기
                                              final assetsAudioPlayer =
                                                  AssetsAudioPlayer();
                                              assetsAudioPlayer.open(
                                                  Audio("assets/main.mp3"));
                                              assetsAudioPlayer.play();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text("탈퇴하기",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 17)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
  }
}
