import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';

class RightPopupTransition {
  // static
  RightPopupTransition._internal();

  static PageRouteBuilder builder({required Widget child}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        LOG.log("Transition!!!");
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
