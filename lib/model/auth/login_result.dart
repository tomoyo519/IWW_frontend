import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';

class SignUpResult {
  final UserModel user;
  final Item pet;

  SignUpResult({
    required this.user,
    required this.pet,
  });
}
