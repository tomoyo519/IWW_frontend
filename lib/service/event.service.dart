// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:iww_frontend/view/modals/todo_first_done.dart';
import 'package:iww_frontend/view/modals/todo_info_snanckbar.dart';
import 'package:lottie/lottie.dart';

enum AppEventType {
  snackbar,
  fullmodal,
}

class AppEvent {
  AppEventType type;
  String title;
  String description;
  Widget? icon;

  AppEvent({
    required this.type,
    required this.title,
    required this.description,
    this.icon,
  });
}

enum EventType {
  // 화면 업데이트 이벤트
  show_todo_snackbar,
  show_first_todo_modal,

  // 유저 상태 업데이트 이벤트
  update_status,
  update_user_hp,
  update_user_reward,
  update_user_pet_exp,
}

//** 앱 내 이벤트를 감지하고 모달 띄울 것을 알려줍니다.
// * 뷰는 플래그를 조건 검사해서 특정 모달을 띄웁니다.
// * 모달을 띄우는 뷰는 main_page.dart
// */
class EventService {
  static final EventService _instance = EventService._internal();
  static final _streamController = StreamController<EventType>.broadcast();

  EventService._internal();
  static Stream<EventType> get stream => _streamController.stream;

  static void publish(EventType event, {String? aux}) {
    LOG.log("Event received: $event");
    _streamController.add(event);
  }

  static void dispose() {
    _streamController.close();
  }

  // void alert(BuildContext context) {
  //   while (_events.isNotEmpty) {
  //     AppEvent front = _events.removeAt(0);
  //     switch (front.type) {
  //       case AppEventType.snackbar:
  //         showCustomSnackBar(
  //           context,
  //           text: front.title,
  //           icon: Lottie.asset(
  //             "assets/star.json",
  //             animate: true,
  //           ),
  //         );
  //         break;
  //       case AppEventType.fullmodal:
  //         if (_table.keys.contains(front.title)) {
  //           showCustomFullScreenModal(
  //             context,
  //             Builder(
  //               builder: _table[front.title]!,
  //             ),
  //           );
  //         }
  //     }
  //   }
  // }
}
