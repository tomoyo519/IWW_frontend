import 'package:flutter/material.dart';
import 'package:iww_frontend/style/button.type.dart';

extension MyButtonStyle on MyButtonType {
  static Color primary = Colors.orange;
  static Color secondary = Colors.grey.shade300;
  static Color onPrimary = Colors.white;
  static Color onSecondary = Colors.black;
  static Color disabled = Colors.grey.shade200;
  static Color onDisabled = Colors.black;

  Color background() {
    switch (this) {
      case MyButtonType.primary:
        return primary;
      case MyButtonType.secondary:
        return secondary;
      case MyButtonType.disabled:
        return disabled;
      default:
        return primary;
    }
  }

  Color text() {
    switch (this) {
      case MyButtonType.primary:
        return onPrimary;
      case MyButtonType.secondary:
        return onSecondary;
      case MyButtonType.disabled:
        return onDisabled;
      default:
        return onPrimary;
    }
  }
}
