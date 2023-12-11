import 'package:flutter/material.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/style/button.type.dart';

extension MyButtonStyle on MyButtonType {
  Color background() {
    switch (this) {
      case MyButtonType.primary:
        return AppTheme.primary;
      case MyButtonType.secondary:
        return AppTheme.secondary;
      case MyButtonType.shaded:
        return AppTheme.shaded;
      case MyButtonType.tertiary:
        return AppTheme.tertiary;

      case MyButtonType.disabled:
        return AppTheme.disabled;
      default:
        return AppTheme.primary;
    }
  }

  Color text() {
    switch (this) {
      case MyButtonType.primary:
        return AppTheme.onPrimary;
      case MyButtonType.secondary:
        return AppTheme.onSecondary;
      case MyButtonType.shaded:
        return AppTheme.onShaded;
      case MyButtonType.tertiary:
        return AppTheme.onTertiary;
      case MyButtonType.disabled:
        return AppTheme.onDisabled;
      default:
        return AppTheme.primary;
    }
  }
}
