class GroupImg {
  int userId;
  String todoImg;
  String userName;
  bool todoDone;

  GroupImg({
    required this.userId,
    required this.todoImg,
    required this.userName,
    required this.todoDone,
  });

  factory GroupImg.fromJson(Map<String, dynamic> body) {
    return GroupImg(
      userId: body['user_id'],
      todoImg: body['todo_img'],
      todoDone: body['todo_done'],
      userName: body['user_name'],
    );
  }
}
