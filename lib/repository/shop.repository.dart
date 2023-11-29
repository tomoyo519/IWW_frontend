import 'dart:developer';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/shop/shop.model.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';

class ShopRepository {
  Map<String, Map<String, List<ShopInfo>>> dummy = {
    "results": {
      "pet": [
        ShopInfo(
            item_id: 6,
            item_name: 'pet1',
            item_cost: 10,
            item_path: 'assets/pet1.png'),
        ShopInfo(
            item_id: 7,
            item_name: 'pet2',
            item_cost: 20,
            item_path: 'assets/pet2.png'),
      ],
      "furniture": [
        ShopInfo(
            item_id: 1,
            item_name: 'smiling',
            item_cost: 30,
            item_path: 'assets/key.png'),
        ShopInfo(
            item_id: 2,
            item_name: 'crying',
            item_cost: 30,
            item_path: 'assets/potion.png'),
        ShopInfo(
            item_id: 3,
            item_name: 'angry',
            item_cost: 30,
            item_path: 'assets/sword.png'),
      ],
      "emoticon": [
        ShopInfo(
            item_id: 4,
            item_name: 'potion',
            item_cost: 30,
            item_path: 'assets/potion.png'),
        ShopInfo(
            item_id: 5,
            item_name: 'sword',
            item_cost: 30,
            item_path: 'assets/sword.png'),
      ]
    }
  };

  Future<List<ShopInfo>> getPets() async {
    return Future.value(dummy["results"]?["pet"] ?? []);
  }

  Future<List<ShopInfo>> getFuns() async {
    return Future.value(dummy["results"]?["furniture"] ?? []);
  }

  Future<List<ShopInfo>> getEmoj() async {
    return Future.value(dummy["results"]?["emoticon"] ?? []);
  }

  Future<bool> purchaseItem(itemId) async {
    int? userId = await _getUser();
    var json = {"user_id": userId, "item_id": itemId};
    return await RemoteDataSource.post('/item-shop/${userId}/${itemId}')
        .then((res) {
      if (res.statusCode == 201) {
        return true;
      }
      return false;
    });
  }

  Future<int?> _getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("user_id");
  }
}
