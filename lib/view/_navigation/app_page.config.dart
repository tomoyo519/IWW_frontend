// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_page.model.dart';
import 'package:iww_frontend/view/group/groupMain.dart';
import 'package:iww_frontend/view/home/home.dart';
import 'package:iww_frontend/view/mypage/myPage.dart';
import 'package:iww_frontend/view/myroom/myroom.dart';
import 'package:iww_frontend/view/notification/notification.dart';
import 'package:iww_frontend/view/shop/shop_page.dart';

/// ************************ ///
/// *                      * ///
/// *       Navigator      * ///
/// *                      * ///
/// ************************ ///

class AppNavigator extends ChangeNotifier {
  AppNavigator() {
    // 초기 내비게이션 상태
    stack.add(_idx);
  }

  // * ===== navigation status ===== * //
  List<int> stack = [];
  int _idx = 0;

  AppPage get current => ALL_PAGES[_idx];
  bool get isBottomSheetPage => _idx < 5;

  void navigate(int idx) {
    _idx = idx;
    stack = [];
    stack.add(idx);
    notifyListeners();
  }

  void push(int idx) {
    _idx = idx;
    stack.add(idx);
    notifyListeners();
  }

  void pop() {
    stack.removeLast();
    _idx = stack.isEmpty ? 0 : stack.last;
    notifyListeners();
  }

  // * ===== Page Getters ==== * //
  List<AppPage> get ALL_PAGES {
    return [todo, group, room, shop, mypage, notification];
  }

  List<AppPage> get BOTTOM_PAGES {
    return [todo, group, room, shop, mypage];
  }

  List<AppPage> get APPBAR_PAGES {
    return [notification];
  }

  IconButton? get pushback {
    return isBottomSheetPage
        ? null
        : IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              pop();
            },
          );
  }

  // * =====   Page List   ==== * //
  final AppPage todo = AppPage(
    idx: 0,
    label: "할일",
    icon: Icons.check_box_outlined,
    builder: (context) => TodoPage(),
  );

  final AppPage group = AppPage(
    idx: 1,
    label: "그룹",
    icon: Icons.people_alt_outlined,
    builder: (context) => MyGroupPage(),
  );

  final AppPage room = AppPage(
    idx: 2,
    label: "홈",
    icon: Icons.home_outlined,
    builder: (context) => MyRoom(),
  );

  final AppPage shop = AppPage(
    idx: 3,
    label: "상점",
    icon: Icons.shopping_bag_outlined,
    builder: (context) => ShopPage(),
  );

  final AppPage mypage = AppPage(
    idx: 4,
    label: "마이페이지",
    icon: Icons.person_outline_rounded,
    builder: (context) => MyPage(),
  );

  final AppPage notification = AppPage(
    idx: 5,
    label: "알림 히스토리",
    icon: Icons.notifications,
    builder: (context) => MyNotification(),
  );
}

extension AppPageExt on AppPage {
  IconButton toAppbarIcon({
    required void Function()? onPressed,
    required IconData icon,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
