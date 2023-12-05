import 'package:flutter/material.dart';

extension StringExt on String? {
  // Tod type으로 캐스팅
  TimeOfDay? toTimeOfDay() {
    if (this == null) return null;
    List<String> parsed = this!.split(":");
    int hour = int.parse(parsed[0]);
    int min = int.parse(parsed[1]);
    return TimeOfDay(hour: hour, minute: min);
  }

  // DateTime type으로 캐스팅
  DateTime? toDateTime() {
    if (this == null) return null;
    List<String> parsed = this!.split('-');
    int year = int.parse(parsed[0]);
    int month = int.parse(parsed[1]);
    int day = int.parse(parsed[2]);
    return DateTime(year, month, day);
  }
}
