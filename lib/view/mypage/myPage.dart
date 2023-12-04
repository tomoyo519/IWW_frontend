import 'package:flutter/material.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/view/mypage/myInfoEdit.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = context.read<UserInfo>();
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
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 4.0),
                                  child: Text(
                                    userInfo.userTel,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    25), // border-radius 설정
                                border: Border.all(
                                    color: Colors.black), // 테두리 색상 설정
                              ),
                              child: TextButton(
                                child: Text(" 프로필 관리"),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: Duration(
                                          milliseconds: 100), // 0.5초로 설정
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          MyInfoEdit(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin = Offset(1.0, 0.0);
                                        var end = Offset.zero;
                                        var tween =
                                            Tween(begin: begin, end: end);

                                        return SlideTransition(
                                          position: tween.animate(animation),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
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
                          animate: true, width: 50, height: 50),
                      Text("보유 캐시"),
                      Text(userInfo.userHp.toString() + '원')
                    ],
                  ),
                  Column(
                    children: [
                      Lottie.asset("assets/star.json",
                          animate: true, width: 50, height: 50),
                      Text("경험치"),
                      Text(userInfo.userHp.toString() + 'P')
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
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
                    Text("공지사항"),
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
