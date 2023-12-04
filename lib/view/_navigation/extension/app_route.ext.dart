import 'package:iww_frontend/view/_navigation/enum/app_route.dart';

extension AppRouteExt on int {
  AppRoute get route {
    return (this < AppRoute.values.length)
        ? AppRoute.values[this]
        : AppRoute.todo;
  }
}
