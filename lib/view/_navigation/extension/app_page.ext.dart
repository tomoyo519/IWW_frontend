import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_navigation/app_page.model.dart';

extension AppPageExt on AppPage {
  IconButton toAppbarIcon({
    required void Function()? onPressed,
    required IconData icon,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
