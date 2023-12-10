import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_navigation/app_page.model.dart';

extension AppPageExt on AppPage {
  Widget toAppbarWidget({
    required void Function()? onPressed,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: child,
    );
  }
}
