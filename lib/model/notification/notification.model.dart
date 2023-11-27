import 'dart:ffi';

class Notification {
  String notiId;
  String receiverId;
  String senderId;
  Int notiType;
  Int reqType;

  Notification({
    required this.notiId,
    required this.receiverId,
    required this.senderId,
    required this.notiType,
    required this.reqType,
  });

  Map<String, dynamic> toJson() {
    return {
      'noti_id': notiId,
      'receiver_id': receiverId,
      'sender_id': senderId,
      'noti_type': notiType,
      'req_type': reqType,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> body) {
    return Notification(
      notiId: body['noti_id'],
      receiverId: body['receiver_id'],
      senderId: body['sender_id'],
      notiType: body['noti_type'],
      reqType: body['req_type'],
    );
  }
}
