// 유저의 로그인 상태
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';

enum LoginStatus {
  permission,
  success,
  cancelled,
}

// 카카오로그인에서 반환하는 로그인 정보
class LoginResult {
  LoginStatus status;
  UserInfo? user;

  LoginResult({
    required this.status,
    required this.user,
  });
}
