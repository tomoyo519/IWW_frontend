import 'package:flutter/material.dart';

extension TimeOfDayExt on TimeOfDay? {
  // 서버 데이터 전송 문자열로 포맷팅
  String? toDataString() {
    if (this == null) return null;
    String hour = this!.hour.toString().padLeft(2, '0');
    String min = this!.minute.toString().padLeft(2, '0');
    return '$hour:$min:00';
  }

  // 화면에 보여주는 문자열로 포맷팅
  String? toViewString() {
    if (this == null) return null;
    String hour = this!.hour.toString().padLeft(2, '0');
    String min = this!.minute.toString().padLeft(2, '0');
    String noon = this!.hour > 12 ? "오후" : "오전";
    return '$noon $hour시 $min분';
  }
}
