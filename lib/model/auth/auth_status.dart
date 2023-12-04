// 유저의 로그인 상태
import 'package:iww_frontend/model/user/user.model.dart';

enum AuthStatus {
  permission,
  success,
  failed,
  waiting,
  initialized,
}
