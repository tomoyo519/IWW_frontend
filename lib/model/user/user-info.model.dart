// ignore_for_file: non_constant_identifier_names

// 현재 유저의 정보
class UserInfo {
  // DB의 유저 테이블 컬럼
  final int user_id;
  final String user_name;
  final String user_tel;
  final String user_kakao_id;
  final int user_hp;

  // TODO: 유저 돈
  int user_money = 45000;

  // DB의 유저 펫
  int? pet_id;

  UserInfo({
    required this.user_id,
    required this.user_name,
    required this.user_tel,
    required this.user_kakao_id,
    required this.user_hp,
    this.pet_id,
  });

  // TODO: regAt, uptAt, lastLogin?

  factory UserInfo.fromJson(Map<String, dynamic> data) {
    return UserInfo(
        user_id: data["user_id"],
        user_name: data["user_name"],
        user_tel: data["user_tel"],
        user_kakao_id: data["user_kakao_id"],
        user_hp: data["user_hp"]);
  }
}
