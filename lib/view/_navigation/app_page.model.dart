import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';

// 단일 페이지 정보
class AppPage<T> {
  final AppRoute idx;
  final String label;
  final IconData icon;
  final T Function(BuildContext context) builder;

  AppPage({
    required this.idx,
    required this.label,
    required this.icon,
    required this.builder,
  });
}
