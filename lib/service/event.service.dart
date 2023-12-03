// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/modals/login_achieve_modal.dart';
import 'package:iww_frontend/view/modals/todo_first_done.dart';
import 'package:iww_frontend/view/modals/custom_snackbar.dart';
import 'package:lottie/lottie.dart';

class Event {
  final EventType type;
  final String? message;

  Event({
    required this.type,
    this.message,
  });
}

enum EventType {
  // 화면 업데이트 이벤트
  show_todo_snackbar,
  show_first_todo_modal,
  show_login_achieve,
}

extension EventTypeExtension on EventType {
  void run(BuildContext context, {String? message}) async {
    switch (this) {
      case EventType.show_first_todo_modal:
        showTodoFirstDoneModal(context);
        break;
      case EventType.show_todo_snackbar:
        showCustomSnackBar(
          context,
          text: message ?? "",
          icon: Lottie.asset("assets/star.json"),
        );
        break;
      case EventType.show_login_achieve:
        showLoginAchieveModal(context);
        break;
      default:
        break;
    }
  }
}

//** 앱 내 이벤트를 감지하고 모달 띄울 것을 알려줍니다.
// * 뷰는 플래그를 조건 검사해서 특정 모달을 띄웁니다.
// * 모달을 띄우는 뷰는 main_page.dart
// */
class EventService {
  static final EventService _instance = EventService._internal();
  static final _streamController = StreamController<Event>.broadcast();
  static int? _userId;

  EventService._internal();
  static Stream<Event> get stream => _streamController.stream;

  // 이벤트 발행
  static void publish(Event event) {
    LOG.log("Event received: ${event.type}");
    _streamController.add(event);
  }

  // 해제
  static void dispose() {
    _streamController.close();
  }

  // AuthService login 완료 후 초기화
  static void setUserId(int userId) {
    _userId = userId;
  }
}
