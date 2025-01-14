import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/model/mypage/reward.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';

class GetUserResult {
  final UserModel user;
  final Item pet;
  final Rewards? reward;

  GetUserResult({
    required this.user,
    required this.pet,
    this.reward,
  });
}
