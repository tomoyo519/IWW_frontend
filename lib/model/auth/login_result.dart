// 유저의 로그인 상태
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';

enum LoginStatus {
  neewSignup,
  complete,
  cancelled,
}

// 카카오로그인에서 반환하는 로그인 정보
class LoginResult {
  LoginStatus status;
  User? user;

  LoginResult({
    required this.status,
    required this.user,
  });
}
