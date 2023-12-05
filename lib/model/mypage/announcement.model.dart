class Announce {
  int annoId;
  String title;
  DateTime regAt;

  Announce({
    required this.annoId,
    required this.title,
    required this.regAt,
  });

  factory Announce.fromJson(Map<String, dynamic> body) {
    return Announce(
      annoId: body['anno_id'],
      title: body['title'],
      regAt: body['reg_at'],
    );
  }
}
