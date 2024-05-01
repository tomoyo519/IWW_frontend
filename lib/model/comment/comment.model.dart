class Comment {
  String comId;
  String authorId;

  late String userImage;
  String authorName;
  String content;
  bool isMod;

  Comment({
    required this.comId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.isMod,
  }) {
    //FIXME - 이미지 경로 수정, 주의!!!! 없는 이미지 요청하면 서버가 터집니다.
    // userImage = '${Secrets.REMOTE_SERVER_URL}/image/$authorId.jpg';
    userImage = 'assets/profile.png';
  }
}
