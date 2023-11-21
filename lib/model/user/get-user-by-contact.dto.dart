class GetUsersByContactsDto {
  List<String>? contacts;

  GetUsersByContactsDto(this.contacts);

  Map<String, dynamic> toJson() {
    return {'contacts': contacts};
  }
}
