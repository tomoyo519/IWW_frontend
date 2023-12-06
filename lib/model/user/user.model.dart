// 현재 유저의 정보
// ignore_for_file: non_constant_identifier_names

class UserModel {
  // DB의 유저 테이블 컬럼
  final int user_id;
  final String user_name;
  final String user_tel;
  final String user_kakao_id;
  final int user_hp;
  final int user_cash;
  final int login_cnt;
  final int login_seq;
  final String last_login;

  late int todo_today_total;
  late int todo_today_done;

  UserModel({
    required this.user_id,
    required this.user_name,
    required this.user_tel,
    required this.user_kakao_id,
    required this.user_hp,
    required this.user_cash,
    required this.login_cnt,
    required this.login_seq,
    required this.last_login,
  })  :
        // late constructor
        todo_today_done = 0,
        todo_today_total = 0;

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      user_id: data["user_id"],
      user_name: data["user_name"],
      user_tel: data["user_tel"],
      user_kakao_id: data["user_kakao_id"],
      user_hp: data["user_hp"],
      user_cash: data['user_cash'],
      login_cnt: data['login_cnt'],
      login_seq: data['login_seq'],
      last_login: data['last_login'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": user_id,
      "user_name": user_name,
      "user_tel": user_tel,
      "user_kakao_id": user_kakao_id,
      "user_hp": user_hp,
      "user_cash": user_cash,
      "login_cnt": login_cnt,
      "login_seq": login_seq,
      "last_login": last_login,
    };
  }
}
