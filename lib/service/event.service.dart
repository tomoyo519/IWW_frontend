// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/modals/custom_snackbar.dart';
import 'package:iww_frontend/view/modals/friend_request_modal.dart';
import 'package:iww_frontend/view/modals/login_achieve_modal.dart';
import 'package:iww_frontend/view/modals/pet_evolve_modal.dart';
import 'package:iww_frontend/view/modals/todo_approved_modal.dart';
import 'package:iww_frontend/view/modals/todo_confirm_modal.dart';
import 'package:iww_frontend/view/modals/todo_first_done.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Event {
  final EventType type;
  final String? message;
  bool? background;

  Event({
    required this.type,
    this.message,
    this.background,
  });
}

// TODO: 파일 분리
enum EventType {
  // Socket Event
  friendRequest,
  friendResponse,
  confirmRequest,
  confirmResponse,
  newComment,
  // UI Event
  onAppLogin,
  onSnsAuth,
  onAchieve,
  onPetEvolve,
  onTodoDone,
  onFirstTodoDone,
  onTodoApproved,
}

extension EventTypeExtension on EventType {
  String get target {
    switch (this) {
      case EventType.friendRequest:
      case EventType.friendResponse:
      case EventType.confirmRequest:
      case EventType.confirmResponse:
      case EventType.newComment:
        return "socket";
      case EventType.onSnsAuth:
      case EventType.onAchieve:
      case EventType.onTodoDone:
      case EventType.onPetEvolve:
      case EventType.onFirstTodoDone:
      case EventType.onTodoApproved:
        return "ui";
      default:
        return '';
    }
  }

  Future<Object?> show(BuildContext context, {String? message}) async {
    switch (this) {
      // ==== UI ==== //
      case EventType.onFirstTodoDone:
        return showTodoDoneModal(context);

      case EventType.onTodoDone:
        // showCustomSnackBar(
        //   context,
        //   text: message ?? "",
        //   icon: Lottie.asset("assets/star.json"),
        // );
        break;
      case EventType.onSnsAuth:
        showCustomSnackBar(
          context,
          text: message ?? "",
          icon: Icon(Icons.mail),
        );
      case EventType.onAchieve:
        return showLoginAchieveModal(context, message!);
      case EventType.onPetEvolve:
        //TODO - 진화 시 소리넣기
        return showPetEvolveModal(context);
      case EventType.onTodoApproved:
        return showTodoApprovedModal(context, message: message!);
      default:
        break;
    }
    return null;
  }

  void run(BuildContext context, {String? message}) async {
    AppNavigator nav = Provider.of<AppNavigator>(context, listen: false);

    switch (this) {
      // ==== SOCKET ==== //
      case EventType.friendRequest:
        showFriendRequestModal(context, message);
        break;
      case EventType.friendResponse:
      case EventType.confirmResponse:
        if (message != null) {
          var data = jsonDecode(message);
          int ownerId = data['senderId'];
          nav.navigate(AppRoute.room, argument: ownerId.toString());
        }
        break;
      case EventType.confirmRequest:
        // LOG.log(message!);
        showTodoConfirmModal(context, message);
        break;
      case EventType.newComment:
        nav.navigate(AppRoute.room);
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
  static final _streamController = StreamController<Event>.broadcast();
  static String? _userId;
  static late IO.Socket socket;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late UserInfo userInfo; // unique
  DateTime? lastNoti; // 중복된 알림 수신 방지용 타임스탬프

  bool filterEvents() {
    DateTime secondEarlier = DateTime.now().subtract(Duration(seconds: 1));
    bool rtn = (lastNoti != null && lastNoti!.isAfter(secondEarlier));
    lastNoti = DateTime.now();
    return rtn;
  }

  EventService.initialize(this.userInfo) {
    print(_userId);
    socket = IO
        .io('${Secrets.REMOTE_SERVER_URL}?user_id=$_userId', <String, dynamic>{
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
      if (filterEvents()) return; // 추가
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
      onSelectNotification: (String? payload) {
        if (payload != null) {
          // payload를 Event 객체로 변환
          // LOG.log("onSelect :" + payload);
          Event event = _convertPayloadToEvent(payload);
          _streamController.add(event); // Event 객체를 스트림에 추가
        }
      },
    );
  }

  // payload를 Event 객체로 변환하는 함수
  static Event _convertPayloadToEvent(String payload) {
    // payload를 파싱하여 Event 객체 생성
    // 예: JSON 형식의 문자열을 파싱하여 Event 필드를 채움
    Map<String, dynamic> data = jsonDecode(payload);
    EventType type;
    String message = payload;
    switch (data['type']) {
      case 'friendRequest':
        type = EventType.friendRequest;
        break;
      case 'friendResponse':
        type = EventType.friendResponse;
        break;
      case 'confirmRequest':
        type = EventType.confirmRequest;
        break;
      case 'confirmResponse':
        type = EventType.confirmResponse;
        break;
      case 'newComment':
        type = EventType.newComment;
        break;
      default:
        type = EventType.newComment;
    }
    // LOG.log("convert payload to event" + message);
    return Event(type: type, message: message);
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
      'message': data['message'],
      'senderId': data['senderId'],
      'senderName': data['senderName'],
      'receiverId': data['receiverId'],
      'notiId': data['notiId'],
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

    // final MyRoomViewModel myRoomViewModel = Provider.of<MyRoomViewModel>(context, listen: false);

    String payload = jsonEncode({
      'type': 'friendResponse',
      'senderId': data['senderId'],
      'receiverId': data['receiverId'],
      'message': data['message']
    });

    // int currentRoomOwnerId = myRoomViewModel.getRoomOwner;

    // if (senderId == currentRoomOwnerId) {
    //   await myRoomViewModel.fetchFriendStatus();
    // }

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

    String payload = jsonEncode({
      'type': 'confirmRequest',
      'senderId': data['senderId'],
      'senderName': data['senderName'],
      'todoId': data['todoId'],
      'todoName': data['todoName'],
      'todoImg': data['todoImg'],
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

    // await flutterLocalNotificationsPlugin.show(
    //   3,
    //   'todo 인증 확인',
    //   '${data['message']}',
    //   generalDetails,
    //   payload: payload,
    // );

    Map<String, dynamic> message = {
      'message': data['message'],
    };

    // 유저 정보 갱신
    await userInfo.handleGroupCheck(message: message);
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

  // static Future _onSelectNotification(
  //     String? payload, BuildContext context) async {
  //   if (payload != null) {
  //     // 알림 선택 시 로직
  //     // 예: payload에 따라 특정 모달 띄우기 또는 페이지로 리디렉트
  //     Map<String, dynamic> payloadData = json.decode(payload);

  //     // 파싱된 데이터에서 정보 추출
  //     var type = payloadData['type'];
  //     var senderId = payloadData['senderId'];

  //     // AppNavigator 인스턴스 접근
  //     AppNavigator nav = Provider.of<AppNavigator>(context, listen: false);

  //     // 알림 유형에 따라 적절한 처리 수행
  //     switch (type) {
  //       case 'friendRequest':
  //       case 'friendResponse':
  //       case 'confirmResponse':
  //         // MyRoom 페이지로 이동
  //         nav.navigate(AppRoute.room); // AppRoute.room은 MyRoom 페이지를 가리키는 예시입니다.
  //         break;
  //       case 'confirmRequest':
  //         _showConfirmRequestModal(context, senderId, payloadData);
  //         break;
  //       case 'newComment':
  //         _navigateToMyRoomAndShowComments(context, senderId);
  //         break;
  //     }
  //   }
  // }
}
