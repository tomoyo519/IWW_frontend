class UserAttandance {
  // DB의 유저 테이블 컬럼
  final int user_id;
  final String atte_at;
  final String day_of_week;

  UserAttandance({
    required this.user_id,
    required this.atte_at,
    required this.day_of_week,
  });

  factory UserAttandance.fromJson(Map<String, dynamic> data) {
    return UserAttandance(
      user_id: data["user_id"],
      atte_at: data["atte_at"],
      day_of_week: data["day_of_week"],
    );
  }
}
