import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'dart:math' as math;

class CircleGauge extends StatefulWidget {
  const CircleGauge({Key? key, required this.percent, required this.width})
      : super(key: key);
  final double width;
  final double percent;

  @override
  State<StatefulWidget> createState() => _CircleGaugeState();
}

class _CircleGaugeState extends State<CircleGauge>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // 위젯이 그려지고 난 후 호출
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      aimationController.addListener(() {
        setState(() {});
      });
      aimationController.forward();
    });
  }

  late final aimationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.transparent,
        child: CustomPaint(
          foregroundPainter: WalkerPainter(
            percent: widget.percent * aimationController.value,
          ),
        ),
      ),
    );
  }
}

class WalkerPainter extends CustomPainter {
  WalkerPainter({
    required this.percent,
  }) : assert(percent >= 0 && percent <= 1,
            "percent must be between 0.0 and 1.0");
  double percent;
  final int emptyAngle = 57;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    double startAngle = (math.pi / 2) +
        math.pi * emptyAngle / 360; // 시작점 - 6시 방향에 원점 맞춘 후 각도만큼 이동
    double endAngle = 2 * math.pi - math.pi * emptyAngle * 2 / 360; // 끝점

    Paint gaugePaint = Paint()
      ..shader = ui.Gradient.linear(const Offset(0, 0),
          Offset(size.width, size.height), const [Colors.orange, Colors.orange])
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint defaultPanit = Paint()
      ..color = const Color(0xFFC4C4C4)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double gaugeRadius = math.min(
        size.width / 2 - gaugePaint.strokeWidth / 2,
        size.height / 2 -
            gaugePaint.strokeWidth / 2); // 원의 반지름을 구함. 선의 굵기에 영향을 받지 않게 보정함.

    // 회색 기본게이지
    canvas.drawArc(Rect.fromCircle(center: center, radius: gaugeRadius),
        startAngle, endAngle, false, defaultPanit);

    // 그라디언트 퍼센트 게이지
    canvas.drawArc(Rect.fromCircle(center: center, radius: gaugeRadius),
        startAngle, endAngle * percent, false, gaugePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
