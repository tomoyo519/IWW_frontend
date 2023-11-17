import 'dart:developer';

import 'package:iww_frontend/screens/landing.model.dart';
import 'package:iww_frontend/webservice.dart';

/// 유저 관련 서버 리포지토리
class UserRemoteRepository {
  static final webService = WebService.instance;

  void createUser(UserLoginModel userLoginModel) {
    String response = webService.createUser(userLoginModel).toString();
    log("create user success $response");
  }
}
