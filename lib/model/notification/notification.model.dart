class Notification {
  String notiId;
  String receiverId;
  String receiverName;
  String senderId;
  String senderName;
  String notiType;
  String subId;
  String? todoTitle;
  String? reqType;

  Notification({
    required this.notiId,
    required this.receiverId,
    required this.receiverName,
    required this.senderId,
    required this.senderName,
    required this.notiType,
    required this.reqType,
    required this.subId,
    required this.todoTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'noti_id': notiId,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'sender_id': senderId,
      'sender_name': senderName,
      'sub_id': subId,
      'noti_type': notiType,
      'req_type': reqType,
      'todo_title': todoTitle,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> body) {
    return Notification(
      notiId: body['noti_id'].toString(),
      receiverId: body['receiver_id'].toString(),
      receiverName: body['receiver_name'],
      senderId: body['sender_id'].toString(),
      senderName: body['sender_name'],
      subId: body['sub_id'],
      notiType: body['noti_type'],
      reqType: body['req_type'],
      todoTitle: body['todo_name'],
    );
  }
}
