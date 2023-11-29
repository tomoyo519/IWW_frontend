import 'package:iww_frontend/secrets/secrets.dart';

class Comment {
  String comId;
  String authorId;

  late String userImage;
  String username;
  String content;
  bool isMod;

  Comment({
    required this.comId,
    required this.authorId,
    required this.username,
    required this.content,
    required this.isMod,
  }) {
    // TODO 서버파괴자의 주범 잡았다.
    // userImage = '${Secrets.TEST_SERVER_URL}/image/$authorId.jpg';
    userImage = 'assets/profile.jpg';
  }
}
