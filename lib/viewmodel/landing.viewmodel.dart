import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/create-user.dto.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/utils/kakaoLogin.dart';

/// 뷰모델
class LandingViewModel extends ChangeNotifier {
  static final KaKaoLogin kakaoLogin = KaKaoLogin.instance;
  final UserRepository userRepository;

  LandingViewModel(this.userRepository);

  // 현재 로그인 토큰이 있는지 확인
  Future<bool> isLoggedIn() async {
    return await userRepository.getUserId() != null;
  }

  // 현재 유저가 가입된 유저인지 확인
  Future<bool> isRegistered(String kakaoId) async {
    return await userRepository
        .getUserByKakaoId(kakaoId)
        .then((user) => user != null);
  }

  // 카카오 로그인 버튼을 누르면 실행
  Future<CreateUserDto?> handleKakaoLogin() async {
    var user = await kakaoLogin.login();
    if (user == null) {
      return null;
    } else {
      return CreateUserDto(
          user.kakaoAccount?.profile?.nickname, null, user.id.toString());
    }
  }
}
