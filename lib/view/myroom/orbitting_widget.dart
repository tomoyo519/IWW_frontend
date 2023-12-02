import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';
import 'package:provider/provider.dart';

class OrbitingWidget extends StatefulWidget {
  const OrbitingWidget({super.key});

  @override
  State<OrbitingWidget> createState() => _OrbitingWidgetState();
}

class _OrbitingWidgetState extends State<OrbitingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _left = 0.0;
  double _top = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);
    _animation = Tween(begin: 0.0, end: pi * 2).animate(_controller);

    _controller.addListener(() {
      setState(() {
        double width = MediaQuery.of(context).size.width / 6; // 화면의 가로 중앙값
        double height = MediaQuery.of(context).size.height / 22; // 화면의 세로 중앙값

        _left = width + cos(_animation.value) * 20; // 타원의 가로 반경
        _top = height + sin(_animation.value) * 10; // 타원의 세로 반경
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var roomState = context.watch<MyRoomViewModel>();
    LOG.log('##################: $_left, $_top');

    return Positioned(
      left: _left,
      top: _top,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: roomState.getPetWidget(),
      ),
    );
  }
}
