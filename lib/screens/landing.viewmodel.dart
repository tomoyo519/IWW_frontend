import 'package:iww_frontend/model/user/create-user.dto.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/utils/kakaoLogin.dart';

/// 뷰모델
class LandingViewModel {
  static final KaKaoLogin kakaoLogin = KaKaoLogin.instance;

  // 카카오 로그인 버튼을 누르면 실행
  Future<CreateUserDto?> handleKakaoLogin() async {
    var user = await kakaoLogin.login();
    if (user == null) {
      throw Exception("잘못된 카카오계정 정보");
    } else {
      // TODO: 여기서 로컬에 쌓을 것 있는지 확인
      return CreateUserDto(
          user.kakaoAccount?.profile?.nickname, null, user.id.toString());
    }
  }
}
