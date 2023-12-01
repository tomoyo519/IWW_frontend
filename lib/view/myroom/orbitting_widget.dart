import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';

class OrbitingWidget extends StatefulWidget {
  const OrbitingWidget({super.key});

  @override
  State<OrbitingWidget> createState() => _OrbitingWidgetState();
}

class _OrbitingWidgetState extends State<OrbitingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _left = 100.0;
  double _top = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: pi * 2).animate(_controller);

    _controller.addListener(() {
      setState(() {
        _left = 100 + cos(_animation.value) * 100;
        _top = 100 + sin(_animation.value) * 50;
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
    LOG.log('##################: $_left, $_top');

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _left,
          top: _top,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.blue,
          ),
        );
      },
    );
  }
}
