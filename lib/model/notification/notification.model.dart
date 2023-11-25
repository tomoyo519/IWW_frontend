import 'dart:ffi';

class Notification {
  String notId;
  String receiverId;
  String senderId;
  Int notiType;
  Int reqType;

  Notification({
    required this.notId,
    required this.receiverId,
    required this.senderId,
    required this.notiType,
    required this.reqType,
  });
}
