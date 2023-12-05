class Rewards {
  String achiName;
  String? achiDesc;
  bool? isHidden;
  String? achiImg;

  Rewards({
    required this.achiName,
    required this.achiDesc,
    required this.isHidden,
    required this.achiImg,
  });

  factory Rewards.fromJson(Map<String, dynamic> body) {
    return Rewards(
      achiName: body['achi_name'],
      achiDesc: body['achi_desc'],
      isHidden: body['is_hidden'],
      achiImg: body['achi_img'],
    );
  }
}
