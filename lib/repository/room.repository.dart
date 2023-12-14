import 'dart:convert';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/utils/logger.dart';

class RoomRepository {
  // 특정 유저의 룸 정보 가져오기
  Future<List<Item>> getItemsOfMyRoom(int userId) async {
    return await RemoteDataSource.get('/room/$userId').then((response) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      List<Item> items = (parsedJson['result'] as List<dynamic>)
          .map((item) => Item.fromJson(item))
          .toList();

      int index = items.indexWhere((item) => item.id == 105);
      if (index != -1) {
        Item itemToMove = items[index];
        items.removeAt(index);
        items.insert(0, itemToMove);
      }

      return items;
    });
  }

  Future<List<Item>> getPetsOfInventory(int userId) async {
    return await RemoteDataSource.get('/item-inventory/$userId/1')
        .then((response) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      List<Item> pets = (parsedJson['result'] as List<dynamic>)
          .map((item) => Item.fromJson(item))
          .toList();

      for (var element in pets) {
        LOG.log('[Inventory Pet]: ${element.name}, ${element.itemType}}');
      }

      return pets;
    });
  }

  // NOTE 하위 3개의 함수의 인자 userId는 항상 나 자신의 userId 입니다.
  // 나의 인벤토리 정보 가져오기
  Future<List<Item>> getItemsOfInventory(int userId) async {
    return await RemoteDataSource.get('/item-inventory/$userId/2')
        .then((response) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      List<Item> items = (parsedJson['result'] as List<dynamic>)
          .map((item) => Item.fromJson(item))
          .toList();

      // for (var element in items) {
      //   LOG.log('[Inventory item]: ${element.name}, ${element.itemType}');
      // }

      return items;
    });
  }

  Future<bool> applyChanges(int userId, List<int> items) {
    return RemoteDataSource.put('/room/$userId', body: {'items': items})
        .then((response) {
      LOG.log('[Apply changes status] ${response.body}');
      return true;
    });
  }

  // 나의의 룸에 아이템 추가하기
  Future<void> addItemToMyRoom(int userId, int itemId) async {
    return await RemoteDataSource.post('/room/$userId/$itemId', body: {})
        .then((response) {
      LOG.log('Add item to my room: ${response.statusCode}');
      LOG.log('Add item to my room: ${response.body}');
    });
  }

  // 나의 룸에서 아이템 삭제하기
  Future<void> removeItemFromMyRoom(int userId, int itemId) async {
    return await RemoteDataSource.delete('/room/$userId/$itemId')
        .then((response) {
      LOG.log('Remove item from my room: ${response.statusCode}');
      LOG.log('Remove item from my room: ${response.body}');
    });
  }
}
