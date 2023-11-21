import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/utils/auth.service.dart';

/// 뷰모델
class LandingViewModel extends ChangeNotifier {
  final AuthService authService;
  LandingViewModel(this.authService);

  // 카카오 로그인 버튼을 누르면 실행
  Future<UserInfo?> login() async {
    return await authService.login();
  }
}
