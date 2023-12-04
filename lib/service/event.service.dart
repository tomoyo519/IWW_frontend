// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/modals/login_achieve_modal.dart';
import 'package:iww_frontend/view/modals/todo_first_done.dart';
import 'package:iww_frontend/view/modals/custom_snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  static final EventService _instance = EventService.initialize();
  static final _streamController = StreamController<Event>.broadcast();
  static String? _userId;
  static late IO.Socket socket;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  EventService.initialize() {
    print(_userId);
    socket =
        IO.io('${Secrets.REMOTE_SERVER_URL}?user_id=$_userId', <String, dynamic>{
      'transports': ['websocket'],
      'query': {'user_id': _userId.toString()},
    });

    // 서버로부터 이벤트 수신 시 처리 로직
    socket.on('connect', (_) {
      print('Succesfully connected to the Server');
    });
    socket.on('friendRequest', (data) {
      _handleFriendRequest(data);
    });
    socket.on('friendResponse', (data) {
      _handleFriendResponse(data);
    });
    socket.on('confirmRequest', (data) {
      _handleConfirmRequest(data);
    });
    socket.on('confirmResponse', (data) {
      _handleConfirmResponse(data);
    });
    socket.on('newComment', (data) {
      _handleNewComment(data);
    });

    _initNotifications();
  }
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
    _userId = userId.toString();
  }

  static void sendEvent(String eventName, dynamic data) {
    socket.emit(eventName, data);
  }

  static void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future _handleFriendRequest(dynamic data) async {
    // 서버 이벤트에 따른 알림 생성
    var androidDetails = AndroidNotificationDetails('channelId', 'channelName',
        importance: Importance.max, priority: Priority.high);
    var iOSDetails = IOSNotificationDetails();
    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    String payload = jsonEncode({
      'type': 'friendRequest',
      'senderId': data['senderId'],
      'receiverId': data['receiverId'],
      'message': data['message']
    });

    await flutterLocalNotificationsPlugin.show(
      0,
      '친구 추가 요청',
      '${data['message']}',
      generalDetails,
      payload: payload,
    );
  }

  Future _handleFriendResponse(dynamic data) async {
    // 서버 이벤트에 따른 알림 생성
    var androidDetails = AndroidNotificationDetails('channelId', 'channelName',
        importance: Importance.max, priority: Priority.high);
    var iOSDetails = IOSNotificationDetails();
    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    String payload = jsonEncode({
      'type': 'friendResponse',
      'senderId': data['senderId'],
      'receiverId': data['receiverId'],
      'message': data['message']
    });

    await flutterLocalNotificationsPlugin.show(
      1,
      '친구 추가 응답',
      '${data['message']}',
      generalDetails,
      payload: payload,
    );
  }

  Future _handleConfirmRequest(dynamic data) async {
    // 서버 이벤트에 따른 알림 생성
    var androidDetails = AndroidNotificationDetails('channelId', 'channelName',
        importance: Importance.max, priority: Priority.high);
    var iOSDetails = IOSNotificationDetails();
    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    String payload = json.encode({
      'type': 'confirmRequest',
      'senderId': data['senderId'],
      'photoUrl': data['photoUrl'],
      'message': data['message']
    });

    await flutterLocalNotificationsPlugin.show(
      2,
      'todo 인증 요청',
      '${data['message']}',
      generalDetails,
      payload: payload,
    );
  }

  Future _handleConfirmResponse(dynamic data) async {
    // 서버 이벤트에 따른 알림 생성
    var androidDetails = AndroidNotificationDetails('channelId', 'channelName',
        importance: Importance.max, priority: Priority.high);
    var iOSDetails = IOSNotificationDetails();
    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    String payload = jsonEncode({
      'type': 'confirmResponse',
      'senderId': data['senderId'],
      'receiverId': data['receiverId'],
      'message': data['message']
    });

    await flutterLocalNotificationsPlugin.show(
      3,
      'todo 인증 확인',
      '${data['message']}',
      generalDetails,
      payload: payload,
    );
  }

  Future _handleNewComment(dynamic data) async {
    // 서버 이벤트에 따른 알림 생성
    var androidDetails = AndroidNotificationDetails('channelId', 'channelName',
        importance: Importance.max, priority: Priority.high);
    var iOSDetails = IOSNotificationDetails();
    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    String payload = jsonEncode({
      'type': 'newComment',
      'authorId': data['senderId'],
      'comId': data['comId'],
      'message': data['message']
    });

    await flutterLocalNotificationsPlugin.show(
      4,
      '새로운 댓글',
      '${data['message']}',
      generalDetails,
      payload: payload,
    );
  }

  static Future _onSelectNotification(String? payload) async {
    if (payload != null) {
      // 알림 선택 시 로직
      // 예: payload에 따라 특정 모달 띄우기 또는 페이지로 리디렉트
      Map<String, dynamic> payloadData = json.decode(payload);

      // 파싱된 데이터에서 정보 추출
      var type = payloadData['type'];
      var senderId = payloadData['senderId'];
      var receiverId = payloadData['receiverId'];
      var message = payloadData['message'];

      // 알림 유형에 따라 적절한 처리 수행
      switch (type) {
        case 'friendRequest':
          // friendRequest에 대한 처리
          break;
        // 다른 알림 유형에 대한 처리 ...
        case 'friendResponse':
          break;
        case 'confirmRequest':
          break;
        case 'confirmResponse':
          break;
        case 'newComment':
          break;
      }
    }
  }
}
