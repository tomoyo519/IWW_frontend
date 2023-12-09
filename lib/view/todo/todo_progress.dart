import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/utils/extension/int.ext.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

// 할일 상태 바
class TodoProgress extends StatelessWidget {
  TodoProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final model = context.watch<TodoViewModel>();
    final userinfo = context.watch<UserInfo>();

    final cash = NumberFormat('#,##0').format(
      userinfo.userCash,
    );

    DateTime now = DateTime.now();
    String today = DateFormat('M월 d일 E요일', 'ko_KO').format(now);

    // 이번 주의 첫째 날(월요일) 계산
    int daysToMonday = now.weekday - DateTime.monday;
    DateTime monday = now.subtract(Duration(days: daysToMonday));

    // 이번 주의 마지막 날(일요일) 계산
    // int daysToSunday = DateTime.sunday - now.weekday;
    // DateTime sunday = now.add(Duration(days: daysToSunday));

    // print('이번 주의 시작일: $monday');
    // print('이번 주의 종료일: $sunday');

    double progress =
        model.todayTotal == 0 ? 0 : model.todayDone / model.todayTotal;

    Map<String, String> assetPath = {
      "기본펫": "assets/pets/small_fox.glb",
      "구미호_01": "assets/pets/small_fox.glb",
      "구미호_02": "assets/pets/mid_fox.glb",
      "구미호_03": "assets/pets/kitsune.glb",
      "용_01": "assets/pets/monitor_lizard.glb",
      "용_02": "assets/pets/horned_lizard.glb",
      "용_03": "assets/pets/chinese_dragon.glb",
      "불사조_01": "assets/pets/pink_robin.glb",
      "불사조_02": "assets/pets/archers_buzzard.glb",
      "불사조_03": "assets/pets/pheonix.glb",
    };

    return SizedBox(
      width: screen.width,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 241, 241, 241),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                            ),
                            children: [
                              TextSpan(
                                text: today,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "\n오늘의 할일은 무엇인가요",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            children: [
                              _TodayBadge(
                                title: "달성",
                                data: model.todayDone,
                              ),
                              _TodayBadge(
                                title: "미달성",
                                data: model.todayTotal - model.todayDone,
                              ),
                            ],
                          ),
                        )
                      ])),
                  SizedBox(
                    width: screen.width * 0.3,
                    child: ModelViewer(
                      interactionPrompt: InteractionPrompt.none,
                      src: assetPath[userinfo.itemName]!,
                      animationName: 'Idle_A',
                      autoPlay: true,
                      cameraControls: false,
                      cameraOrbit: '25deg 75deg 105%',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
              ),
              height: 5,
              width: screen.width,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 255, 128, 0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TodayBadge extends StatelessWidget {
  final String title;
  final int? data;

  const _TodayBadge({
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ));
  }
}

class CashBadge extends StatelessWidget {
  const CashBadge({
    super.key,
    required this.cash,
  });

  final String cash;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 25,
          height: 25,
          child: Lottie.asset(
            "assets/todo/coin.json",
            animate: false,
          ),
        ),
        Text(
          cash,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        )
      ],
    );
  }
}
