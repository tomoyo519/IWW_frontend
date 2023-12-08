class Item {
  int id;
  String name;
  int itemType;
  String? path;
  String? description;
  String? petName;
  int? petExp;
  String? metadata;

  Item({
    required this.id,
    required this.name,
    required this.itemType,
    this.path,
    this.description,
    this.petName,
    this.petExp,
    this.metadata,
  });

  Item.fromJson(Map<String, dynamic> json)
      : id = json['item_id'],
        name = json['item_name'],
        description = json['item_desc'],
        path = json['item_path'],
        petName = json['pet_name'],
        petExp = json['pet_exp'],
        itemType = json['item_type'],
        metadata = json['metadata'];

  // Map<String, dynamic> toMap() {
  // return {
  //   "item_id": id,
  //   "item_name": name,
  //   "descriptoin"
  // }
  // }
}
