// 유저의 로그인 상태
import 'package:iww_frontend/model/user/user-info.model.dart';

enum AuthStatus {
  permission,
  success,
  failed,
  waiting,
}

// 카카오로그인에서 반환하는 로그인 정보
class AuthUserStatus {
  AuthStatus status;
  UserInfo? user;

  AuthUserStatus({
    required this.status,
    required this.user,
  });
}
