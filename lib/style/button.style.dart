import 'package:flutter/material.dart';
import 'package:iww_frontend/style/button.type.dart';

extension MyButtonStyle on MyButtonType {
  static Color primary = Colors.orange;
  static Color secondary = Colors.grey.shade300;
  static Color onPrimary = Colors.white;
  static Color onSecondary = Colors.black54;

  Color background() {
    switch (this) {
      case MyButtonType.primary:
        return primary;
      case MyButtonType.secondary:
        return secondary;
    }
  }

  Color text() {
    switch (this) {
      case MyButtonType.primary:
        return onPrimary;
      case MyButtonType.secondary:
        return onSecondary;
    }
  }
}
