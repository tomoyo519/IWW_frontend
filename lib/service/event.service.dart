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

//** 앱 내 이벤트를 감지하고 모달 띄울 것을 알려줍니다.
// * 뷰는 플래그를 조건 검사해서 특정 모달을 띄웁니다.
// * 모달을 띄우는 뷰는 main_page.dart
// */
class EventService extends ChangeNotifier {
  final List<AppEvent> _events = [];

  // 미리 정의된 이벤트 모달 테이블
  final Map<String, WidgetBuilder> _table = {
    'first_todo_done': (context) => TodoFirstDoneModal(),
    // 'pet_evolved': () =>
  };

  void input(AppEvent event) {
    LOG.log("Event received: ${event.title}");
    _events.add(event);
    notifyListeners();
  }

  void alert(BuildContext context) {
    while (_events.isNotEmpty) {
      AppEvent front = _events.removeAt(0);
      switch (front.type) {
        case AppEventType.snackbar:
          showCustomSnackBar(
            context,
            text: front.title,
            icon: Lottie.asset(
              "assets/star.json",
              animate: true,
            ),
          );
          break;
        case AppEventType.fullmodal:
          if (_table.keys.contains(front.title)) {
            showCustomFullScreenModal(
              context,
              Builder(
                builder: _table[front.title]!,
              ),
            );
          }
      }
    }
  }
}
