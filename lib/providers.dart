// providers.dart
import 'package:iww_frontend/repository/comment.repository.dart';
import 'package:iww_frontend/repository/friend.repository.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/repository/user.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/utils/kakaoLogin.dart';
import 'package:iww_frontend/view/widget/add_todo.dart';
import 'package:iww_frontend/view/widget/home.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

List<Provider> getRepositories() {
  return [
    Provider<TodoRepository>(create: (_) => TodoRepository()),
    Provider<UserRepository>(create: (_) => UserRepository()),
    Provider<FriendRepository>(create: (_) => FriendRepository()),
    Provider<RoomRepository>(create: (_) => RoomRepository()),
    Provider<CommentRepository>(create: (_) => CommentRepository()),
    Provider<KaKaoLogin>(create: (_) => KaKaoLogin())
  ];
}

List<Provider> getServices() {
  return [
    Provider<AuthService>(
        create: (_) => AuthService(
              Provider.of<KaKaoLogin>(_, listen: false),
              Provider.of<UserRepository>(_, listen: false),
            )),
  ];
}

List<ChangeNotifierProvider> getChangeNotifiers() {
  return [
    ChangeNotifierProvider<NewTodo>(create: (context) => NewTodo()),
  ];
}
