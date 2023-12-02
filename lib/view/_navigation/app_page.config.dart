// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_navigation/app_page.model.dart';
import 'package:iww_frontend/view/group/groupMain.dart';
import 'package:iww_frontend/view/home/home.dart';
import 'package:iww_frontend/view/mypage/myPage.dart';
import 'package:iww_frontend/view/myroom/myroom.dart';
import 'package:iww_frontend/view/shop/shop_page.dart';

/// ************************ ///
/// *                      * ///
/// *       전체 페이지       * ///
/// *                      * ///
/// ************************ ///

List<AppPage> GET_APP_PAGES() {
  // 알림은 기본으로 노출됩니다
  ActionPage notification = ActionPage(
    route: '/notification',
    label: '알림',
    icon: Icons.notifications,
  );
  return [
    AppPage(
      route: "/todo",
      label: "할일",
      icon: Icons.check_box_outlined,
      builder: (context) => TodoPage(),
      appbar: [notification],
    ),
    AppPage(
      route: "/group",
      label: "그룹",
      icon: Icons.people_alt_outlined,
      builder: (context) => MyGroupPage(),
      appbar: [notification],
      // float: ActionPage(
      //   route: '/group/new',
      //   label: '새로운 그룹',
      //   icon: Icons.add,
      // ),
    ),
    AppPage(
      route: "/myroom",
      label: "홈",
      icon: Icons.home_outlined,
      builder: (context) => MyRoom(),
      appbar: [notification],
    ),
    AppPage(
      route: "/shop",
      label: "상점",
      icon: Icons.shopping_bag_outlined,
      builder: (context) => ShopPage(),
      appbar: [
        notification,
        ActionPage(
            route: '/landing',
            label: '펫??',
            icon: Icons.catching_pokemon_outlined),
      ],
    ),
    AppPage(
      route: "/mypage",
      label: "마이페이지",
      icon: Icons.person_outline_rounded,
      builder: (context) => MyPage(),
      appbar: [notification],
    ),
  ];
}
