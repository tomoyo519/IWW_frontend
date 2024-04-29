import 'dart:async';
import 'dart:collection';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/app_page.model.dart';
import 'package:iww_frontend/view/_navigation/extension/app_page.ext.dart';
import 'package:iww_frontend/view/_navigation/extension/app_route.ext.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget implements PreferredSizeWidget {
  MainPage({super.key});

  bool userLoggedIn = false;

  @override
  State<MainPage> createState() => _MainPageState();

  @override
  Size get preferredSize => Size.fromHeight(52);
}

/// ************************ ///
/// *                      * ///
/// *       Main Page      * ///
/// *                      * ///
/// ************************ ///

class _MainPageState extends State<MainPage> {
  bool waiting = false;
  StreamSubscription<Event>? sub;
  final Queue<Event> _eventq = Queue<Event>();
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();

    // * ==== Event Listener ==== * //
    sub = EventService.stream.listen(
      (event) async {
        String? message = event.message;
        EventType type = event.type;
        LOG.log("[Event]: ${message ?? ' '}${type.target.toUpperCase()}");

        if (event.background == true) {
          // 업적 등의 앱 진입 시 생성도는 이벤트에 한해 초기 로딩시간 설정
          await Future.delayed(Duration(seconds: 5));
        }

        if (type.target == 'socket') {
          // 소켓의 경우 즉시
          // ignore: use_build_context_synchronously
          type.run(context, message: message);
        } else if (type.target == 'ui') {
          // UI 렌더링은 큐에 쌓기
          _eventq.add(event);
          if (!_waiting) {
            await _nextEvent();
          }
        }
      },
    );
  }

  Future<void> _nextEvent() async {
    while (_eventq.isNotEmpty) {
      _waiting = true;
      Event event = _eventq.removeFirst();
      String? message = event.message;
      EventType type = event.type;

      // ignore: use_build_context_synchronously
      bool? completed = await type.show(context, message: message) as bool?;
      await Future.delayed(Duration(seconds: 1)); // 이벤트 사이 간격 조정
      LOG.log('event completed? $completed');
      _waiting = false;
    }
  }

  @override
  void dispose() {
    if (sub != null) sub!.cancel();
    super.dispose();
  }

  void requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      // 사용자가 알림 권한을 거부한 경우
      Permission.notification.request();
    }
    // 기타 상태 처리 (granted, permanentlyDenied 등)
  }

  // 무조건 있어야함!
  @override
  Widget build(BuildContext context) {
    AppNavigator nav = context.watch<AppNavigator>();
    final List<AppPage> bottoms = nav.BOTTOM_PAGES;
    final List<AppPage> appbars = nav.APPBAR_PAGES;

    final AppPage curr = nav.current;
    double fs = MediaQuery.of(context).size.width * 0.01;

    // * ==== Trigger Login Event ==== * //
    context.read<UserInfo>().initEvents();

    // LOG.log("${RemoteDataSource.baseHeaders['Authorization']}");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // * ======= APPBAR ======= * //
      appBar: MyAppBar(
        leading: nav.pushback,
        title: Text(nav.title ?? curr.label),
        actions: appbars
            .map(
              (each) => each.toAppbarWidget(
                // 앱 바 아이콘 클릭시 해당 인덱스로 변경
                onPressed: () => nav.push(each.idx),
                child: each.icon,
              ),
            )
            .toList(),
      ),
      // * ======= BODY ======= * //
      body: Builder(
        // 빌더 함수 콜
        builder: (context) => curr.builder(context),
      ),
      bottomNavigationBar: nav.isBottomSheetPage
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: BottomNavigationBar(
                iconSize: 6 * fs,
                currentIndex: nav.current.idx.index,
                onTap: (idx) async {
                  final assetsAudioPlayer = AssetsAudioPlayer();
                  assetsAudioPlayer.open(Audio("assets/main.mp3"));
                  assetsAudioPlayer.play();
                  nav.navigate(idx.route);
                },
                items: bottoms
                    .map((page) => BottomNavigationBarItem(
                          icon: page.icon,
                          label: page.label,
                        ))
                    .toList(),
                type: BottomNavigationBarType.fixed,

                // 선택된 페이지 컬러
                selectedFontSize: 3 * fs,
                unselectedFontSize: 3 * fs,
                selectedItemColor: AppTheme.primary,
                backgroundColor: Colors.white,
              ),
            )
          : null,
    );
  }
}
