import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/extension/app_page.ext.dart';
import 'package:iww_frontend/view/_navigation/extension/app_route.ext.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/app_page.model.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/modals/pet_evolve_modal.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();

    Future.microtask(() async {
      showPetEvolveModal(context);
      // type.run(context, message: message);
    });

    // * ==== Event Listener ==== * //
    EventService.stream.listen(
      (event) async {
        String? message = event.message;
        EventType type = event.type;
        LOG.log("main_page event listen msg : ${message ?? ''} ${type.target}");

        if (type.target == 'socket') {
          type.run(context, message: message);
        } else if (type.target == 'ui') {
          // 로그인 달성 모달인 경우
          if (type == EventType.show_login_achieve && widget.userLoggedIn) {
            Future.microtask(() async {
              // showPetEvolveModal(context);
              type.run(context, message: message);
            });
            widget.userLoggedIn = true;
          } else {
            // 기타 다른 UI 이벤트
            Future.microtask(() async {
              showPetEvolveModal(context);
              // type.run(context, message: message);
            });
          }
        }
      },
    );
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // * ======= APPBAR ======= * //
      appBar: MyAppBar(
        leading: nav.pushback,
        title: Text(nav.title ?? curr.label),
        actions: appbars
            .map(
              (each) => each.toAppbarIcon(
                // 앱 바 아이콘 클릭시 해당 인덱스로 변경
                onPressed: () => nav.push(each.idx),
                icon: each.icon,
              ),
            )
            .toList(),
      ),
      // * ======= BODY ======= * //
      // 종속성 주입 부분
      body: Builder(
        // 빌더 함수 콜
        builder: (context) => curr.builder(context),
      ),
      bottomNavigationBar: nav.isBottomSheetPage
          ? BottomNavigationBar(
              currentIndex: nav.current.idx.index,
              onTap: (idx) {
                nav.navigate(idx.route);
              },
              items: bottoms
                  .map((page) => BottomNavigationBarItem(
                        icon: Icon(page.icon),
                        label: page.label,
                      ))
                  .toList(),
              type: BottomNavigationBarType.fixed,
              // 이 옵션 주면 라벨 text 뜨지않음
              showSelectedLabels: false,
              showUnselectedLabels: false,
              // 선택된 페이지 컬러
              selectedItemColor: Colors.orange)
          : null,
    );
  }
}
