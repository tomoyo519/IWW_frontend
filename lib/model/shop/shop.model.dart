// ignore_for_file: non_constant_identifier_names

// 현재 유저의 정보
class ShopInfo {
  // DB의 유저 테이블 컬럼
  final int item_id;
  final String item_name;
  final int item_cost;
  final String? item_desc;
  final String item_path;

  ShopInfo({
    required this.item_id,
    required this.item_name,
    required this.item_cost,
    required this.item_path,
    this.item_desc,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> data) {
    return ShopInfo(
        item_id: data["item_id"],
        item_name: data["item_name"],
        item_cost: data["item_cost"],
        item_path: data["item_path"],
        item_desc: data["item_desc"]);
  }
}
