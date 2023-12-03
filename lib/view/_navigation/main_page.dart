import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/view/_navigation/app_page.config.dart';
import 'package:iww_frontend/view/_navigation/app_page.model.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:provider/provider.dart';

// 전체 페이지 내비게이터
class MainPage extends StatefulWidget implements PreferredSizeWidget {
  MainPage({super.key});

  final List<AppPage> pages = GET_APP_PAGES();

  @override
  State<MainPage> createState() => _MainPageState();

  @override
  Size get preferredSize => Size.fromHeight(52);
}

/// ************************ ///
/// *                      * ///
/// *       내비게이터        * ///
/// *                      * ///
/// ************************ ///

class _MainPageState extends State<MainPage> {
  int _pageIdx = 0;

  @override
  void initState() {
    super.initState();
    _pageIdx = 0; // 초기 탭을 지정합니다
  }

  // 무조건 있어야함!
  @override
  Widget build(BuildContext context) {
    AppPage currPage = widget.pages[_pageIdx];

    // 앱 내 이벤트 매니저
    final EventService events = Provider.of<EventService>(context);

    // 수신된 알림을 렌더링합니다.
    Future.microtask(() {
      events.alert(context);
    });

    return Scaffold(
      // * ======= APPBAR ======= * //
      appBar: MyAppBar(
        title: Text(currPage.label),
        actions: currPage.appbar
            ?.map(
              // AppPage
              (each) => each.toWidget(context),
            )
            .toList(),
      ),
      // * ======= BODY ======= * //
      // 종속성 주입 부분
      body: currPage.builder(context),
      // * ===== FLOATING BUTTON ===== * //
      floatingActionButton: currPage.float != null
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(
                context,
                currPage.float!.route,
              ),
              child: Icon(
                currPage.float!.icon,
              ),
            )
          : null,
      // * ===== BOTTOMBAR ===== * //
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIdx,
          onTap: (idx) {
            // 탭하면 페이지 인덱스만 바뀝니다
            setState(() {
              _pageIdx = idx;
            });
          },
          items: widget.pages
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
          selectedItemColor: Colors.orange),
    );
  }

  void _handleNotificationSelection(String payload) {
    // 예: payload에 따라 특정 모달 띄우기 또는 특정 페이지로 리디렉트
  }
}
