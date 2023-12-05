import 'dart:convert';
import 'dart:developer';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/shop/shop.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopRepository {
  Map<String, Map<String, List<ShopInfo>>> dummy = {
    "result": {
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

  Future<List<ShopInfo>> getPets(userId) async {
    return await RemoteDataSource.get('/item-shop/${userId ?? 1}').then((res) {
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);
        LOG.log('res.body:${jsonData["result"]}');
        return List<ShopInfo>.from(
            jsonData["result"]["pet"].map((item) => ShopInfo.fromJson(item)));
      } else {
        if (dummy["result"] != null && dummy["result"]!["pet"] != null) {
          return Future.value(List<ShopInfo>.from(dummy["result"]!["pet"]!));
        } else {
          return Future.value([]);
        }
      }
    });
    // return Future.value(dummy["results"]?["pet"] ?? []);
  }

// background
  Future<List<ShopInfo>> getFuns(userId) async {
    return await RemoteDataSource.get('/item-shop/${userId ?? 1}').then((res) {
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);

        LOG.log('res.body:${jsonData["result"]}');
        return List<ShopInfo>.from(jsonData["result"]["background"]
            .map((item) => ShopInfo.fromJson(item)));
      } else {
        if (dummy["result"] != null && dummy["result"]!["background"] != null) {
          return Future.value(
              List<ShopInfo>.from(dummy["result"]!["background"]!));
        } else {
          return Future.value([]);
        }
      }
    });
    // return Future.value(dummy["result"]?["pet"] ?? []);
  }

// motion
  Future<List<ShopInfo>> getEmoj(userId) async {
    return await RemoteDataSource.get('/item-shop/${userId ?? 1}').then((res) {
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);

        LOG.log('res.body:${jsonData["result"]}');
        return List<ShopInfo>.from(jsonData["result"]["motion"]
            .map((item) => ShopInfo.fromJson(item)));
      } else {
        if (dummy["result"] != null && dummy["result"]!["motion"] != null) {
          return Future.value(List<ShopInfo>.from(dummy["result"]!["motion"]!));
        } else {
          return Future.value([]);
        }
      }
    });
    // return Future.value(dummy["result"]?["pet"] ?? []);
  }

  Future<bool> purchaseItem(itemId, userId) async {
    var json = jsonEncode({"user_id": userId ?? 1, "item_id": itemId});
    return await RemoteDataSource.post('/item-shop/${userId ?? 1}/${itemId}',
            body: json)
        .then((res) {
      if (res.statusCode == 201) {
        return true;
      }
      LOG.log('${res.body}');
      return false;
    });
  }

  Future<int?> _getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("user_id");
  }
}
