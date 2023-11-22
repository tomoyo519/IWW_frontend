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
    userImage = '${Secrets.TEST_SERVER_URL}/image/$authorId.jpg';
  }
}
