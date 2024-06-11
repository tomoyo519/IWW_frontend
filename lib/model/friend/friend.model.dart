class FriendInfo {
  int userId;
  String userName;
  int totalExp;
  String petName;

  FriendInfo({
    required this.userId,
    required this.userName,
    required this.totalExp,
    required this.petName,
  });

  FriendInfo.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        userName = json['user_name'],
        totalExp = json['total_exp'],
        petName = json['pet_name'];
}
