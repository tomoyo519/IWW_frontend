import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

// 할일 상태 바
class TodoProgress extends StatefulWidget {
  TodoProgress({super.key});

  @override
  State<TodoProgress> createState() => _TodoProgressState();
}

class _TodoProgressState extends State<TodoProgress> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final model = context.watch<TodoViewModel>();
    final userinfo = context.watch<UserInfo>();

    DateTime now = DateTime.now();
    String today = DateFormat('M월 d일 E요일', 'ko_KO').format(now);

    double progress =
        model.todayTotal == 0 ? 0 : model.todayDone / model.todayTotal;

    // Map<String, String> assetPath = {
    //   "기본펫": "assets/pets/small_fox.glb",
    //   "구미호_01": "assets/pets/small_fox.glb",
    //   "구미호_02": "assets/pets/mid_fox.glb",
    //   "구미호_03": "assets/pets/kitsune.glb",
    //   "용_01": "assets/pets/monitor_lizard.glb",
    //   "용_02": "assets/pets/horned_lizard.glb",
    //   "용_03": "assets/pets/chinese_dragon.glb",
    //   "불사조_01": "assets/pets/pink_robin.glb",
    //   "불사조_02": "assets/pets/archers_buzzard.glb",
    //   "불사조_03": "assets/pets/pheonix.glb",
    // };

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
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.FONT_FAMILY,
                            ),
                            children: [
                              TextSpan(
                                text: today,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26,
                                ),
                              ),
                              TextSpan(
                                text: "\n오늘의 할일은 무엇인가요?",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                _TodayBadge(
                                  title: "달성",
                                  data: model.todayDone,
                                  color: Colors.orange,
                                ),
                                _TodayBadge(
                                  title: "미달성",
                                  data: model.todayTotal - model.todayDone,
                                ),
                              ],
                            ),
                          ),
                        )
                      ])),
                  SizedBox(
                    width: screen.width * 0.4,
                    child: ModelViewer(
                      interactionPrompt: InteractionPrompt.none,
                      src:
                          'assets/pets/${userinfo.mainPet.path!.split('.')[0]}.glb',
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
              height: 10,
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
  Color? color;

  _TodayBadge({
    required this.title,
    required this.data,
    this.color,
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
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: color ?? Colors.black87),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
