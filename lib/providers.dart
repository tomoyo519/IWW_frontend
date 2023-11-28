// providers.dart
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/kakaoLogin.dart';
import 'package:provider/provider.dart';

// 리포지토리 서빙용
List<Provider> getRepositories() {
  return [
    Provider<TodoRepository>(create: (_) => TodoRepository()),
    Provider<UserRepository>(create: (_) => UserRepository()),
    Provider<FriendRepository>(create: (_) => FriendRepository()),
    Provider<RoomRepository>(create: (_) => RoomRepository()),
    Provider<CommentRepository>(create: (_) => CommentRepository()),
    Provider<KaKaoLogin>(create: (_) => KaKaoLogin()),
    Provider<GroupRepository>(create: (_) => GroupRepository())
  ];
}
