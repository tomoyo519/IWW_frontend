import 'package:iww_frontend/service/event.service.dart';

extension EventExt on Event {
  Event of(EventType type, {String? message}) {
    return Event(type: type, message: message);
  }
}
