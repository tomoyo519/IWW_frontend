class Item {
  int id;
  String name;
  int itemType;
  String? path;
  String? description;
  String? petName;
  int? petExp;

  Item({
    required this.id,
    required this.name,
    required this.itemType,
    this.path,
    this.description,
    this.petName,
    this.petExp,
  });

  Item.fromJson(Map<String, dynamic> json)
      : id = json['item_id'],
        name = json['item_name'],
        description = json['item_desc'],
        path = json['item_path'],
        petName = json['pet_name'],
        petExp = json['pet_exp'],
        itemType = json['item_type'];
}
