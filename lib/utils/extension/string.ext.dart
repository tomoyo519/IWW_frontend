import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/utils/weekdays.dart';

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
    // 1. 20xx-xx-xx 형식인 경우
    if (this!.contains('-')) {
      List<String> parsed = this!.split('-');
      int year = int.parse(parsed[0]);
      int month = int.parse(parsed[1]);
      int day = int.parse(parsed[2]);

      return DateTime(year, month, day);
    } else {
      // 2. 20xxxxxx 형식인 경우
      this!.replaceAll('-', '');
      int year = int.parse(this!.substring(0, 4));
      int month = int.parse(this!.substring(4, 6));
      int day = int.parse(this!.substring(6, 8));
      return DateTime(year, month, day);
    }
  }

  WeekRepeat toWeekRepeat() {
    int idx = 0;
    int selected = 0;
    Map<int, String> weekdays = {
      1: "월",
      2: "화",
      3: "수",
      4: "목",
      5: "금",
      6: "토",
      0: "일"
    };

    List<WeekDay> weekday = this!.split('').map((e) {
      if (e == '1') selected++;
      return WeekDay(idx: idx, name: weekdays[idx++]!, selected: e == '1');
    }).toList();

    String name = selected == 7 ? '매일' : '주 $selected 회';

    return WeekRepeat(count: selected, weekday: weekday, name: name);
  }
}
