// Map<String, Widget Function(BuildContext)>
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/utils/login_wrapper.dart';
import 'package:iww_frontend/view/group/groupDetail.dart';
import 'package:iww_frontend/view/group/groupMain.dart';
import 'package:iww_frontend/view/group/newGroup.dart';
import 'package:iww_frontend/view/home/home.dart';
import 'package:iww_frontend/view/mypage/myPage.dart';
import 'package:iww_frontend/view/myroom/myroom.dart';
import 'package:iww_frontend/view/notification/notification.dart';
import 'package:iww_frontend/view/friends/friendMain.dart';
import 'package:iww_frontend/view/signup/add_friends.dart';
import 'package:iww_frontend/view/signup/landing.dart';
import 'package:iww_frontend/view/signup/signup.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/view/shop/shop_page.dart';

final Map<String, WidgetBuilder> ROUTE_TABLE = {
  // 회원가입 또는 랜딩 페이지
  '/signup': (context) => SignUpPage(),
  '/landing': (context) => LandingPage(),

  // 유저만 접근 가능한 페이지
  '/todo': (context) => LoginWrapper(child: TodoPage()),
  '/contact': (context) => LoginWrapper(child: AddFriendsPage()),
  '/myroom': (context) => LoginWrapper(child: MyRoom()),
  '/group': (context) => LoginWrapper(child: MyGroup()),
  '/mypage': (context) => LoginWrapper(child: MyPage()),
  '/friends': (context) => LoginWrapper(child: MyFriend()),
  '/shop': (context) => LoginWrapper(child: ShopPage()),
  '/notification': (context) => LoginWrapper(child: MyNotification()),
  '/group/detail': (context) => LoginWrapper(
      child: GroupDetail(
          group: ModalRoute.of(context)?.settings.arguments as Group)),
  '/group/new': (context) => ChangeNotifierProvider(
        create: (context) => MyGroupViewModel(
            Provider.of<GroupRepository>(context, listen: false)),
        child: LoginWrapper(child: NewGroup()),
      ),
};