import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart' as pi;

// 할일 상태 바
// class TodoProgress extends StatefulWidget {
//   TodoProgress({super.key});

//   @override
//   State<TodoProgress> createState() => _TodoProgressState();
// }

class TodoProgress extends StatelessWidget {
  const TodoProgress({super.key});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double fs = screen.width * 0.01;
    TodoViewModel model = context.watch<TodoViewModel>();
    UserInfo userinfo = context.watch<UserInfo>();

    DateTime now = DateTime.now();
    String today = DateFormat('M월 d일 E요일', 'ko_KO').format(now);
    String filepath = userinfo.mainPet.path!.split('.')[0];

    int todayTotal = model.todayTotal;
    int todayDone = model.todayDone;

    double progress = todayTotal == 0 ? 0 : todayDone / todayTotal;

    return Container(
      padding: EdgeInsets.all(2 * fs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 241, 241, 241),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    today,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 5 * fs,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "오늘의 할일은 무엇인가요?",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 3.5 * fs,
                      fontWeight: FontWeight.normal,
                      fontFamily: AppTheme.font,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 50 * fs,
                    height: 18 * fs,
                    margin: EdgeInsets.symmetric(vertical: 2 * fs),
                    padding: EdgeInsets.symmetric(vertical: fs),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2 * fs),
                    ),
                    child: Row(
                      children: [
                        _TodayBadge(
                          title: "달성",
                          data: model.todayDone,
                          color: AppTheme.primary,
                        ),
                        _TodayBadge(
                          title: "미달성",
                          data: model.todayTotal - model.todayDone,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 30 * fs,
                height: 35 * fs,
                child: ModelViewer(
                  key: ValueKey(filepath),
                  interactionPrompt: InteractionPrompt.none,
                  src: 'assets/pets/$filepath.glb',
                  animationName: 'Idle_A',
                  autoPlay: true,
                  cameraControls: false,
                  disableZoom: true,
                  disablePan: true,
                  touchAction: TouchAction.none,
                  shadowIntensity: 1,
                  shadowSoftness: 1,
                  cameraOrbit: '25deg 75deg 2.5m', // TODO: 확인
                ),
              ),
            ],
          ),
          Expanded(
            child: pi.LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 10 * fs,
              animation: true,
              lineHeight: 5 * fs,
              animationDuration: 800,
              percent: progress,
              center: Text(
                "달성률 $todayDone / $todayTotal",
                style: TextStyle(fontSize: 3.5 * fs),
              ),
              barRadius: Radius.circular(10),
              progressColor: AppTheme.primary,
              backgroundColor: Colors.white,
            ),
          ),
        ],
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
    double fs = MediaQuery.of(context).size.width * 0.01;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.toString(),
            style: TextStyle(
                fontSize: 6 * fs,
                fontWeight: FontWeight.w900,
                color: color ?? Colors.black54),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 3 * fs,
              color: color ?? Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
