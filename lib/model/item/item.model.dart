class Item {
  int id;
  String name;
  String? description;
  String? petName;
  int? petExp;

  Item({
    required this.id,
    required this.name,
    this.description,
    this.petName,
    this.petExp,
  });

  Item.fromJson(Map<String, dynamic> json)
      : id = json['item_id'],
        name = json['item_name'],
        description = json['item_desc'],
        petName = json['pet_name'],
        petExp = json['pet_exp'];
}