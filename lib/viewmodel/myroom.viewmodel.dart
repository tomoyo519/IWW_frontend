import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/model/pet/pet_models.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:iww_frontend/model/item/item.model.dart';

import 'package:iww_frontend/model/pet/pet_models.dart';

class MyRoomViewModel with ChangeNotifier {
  final RoomRepository _roomRepository;
  final int _userId; // 로그인한 사용자의 id
  List<Item> inventory = []; // 사용자의 인벤토리
  int roomOwner; // 현재 있는 방의 주인 (기본값은 로그인한 사용자의 id)
  List<Item> roomObjects = []; // 현재 방에 존재하는 오브젝트 리스트

  MyRoomViewModel(this._userId, this._roomRepository) : roomOwner = _userId {
    fetchInventory();
    fetchMyRoom();
  }

  void fetchMyRoom() async {
    roomObjects = await _roomRepository.getItemsOfMyRoom(roomOwner);
    notifyListeners();
  }

  void fetchInventory() async {
    inventory = await _roomRepository.getItemsOfInventory(_userId);
    notifyListeners();
  }

  void addItemToMyRoom(int itemId) async {
    await _roomRepository.addItemToMyRoom(_userId, itemId);
    fetchMyRoom();
  }

  void removeItemFromMyRoom(int itemId) async {
    await _roomRepository.removeItemFromMyRoom(_userId, itemId);
    fetchMyRoom();
  }

  void changeRoomOwner(int userId) {
    roomOwner = userId;
    fetchMyRoom();
  }

  bool isMyRoom() => _userId == roomOwner;

  /// itemType
  /// 1. pet
  /// 2. furniture
  /// 3. pet's motion
  /// 4. background
  AssetImage getBackgroundImage() {
    for (var element in roomObjects) {
      if (element.itemType == 4) {
        return AssetImage('assets/bg/${element.path}');
      }
    }
    // default background
    return AssetImage('assets/bg/bg15.png');
  }

  ModelViewer getPetWidget() {
    String petName = '';
    for (var element in roomObjects) {
      if (element.itemType == 1) {
        petName = element.path!.split('.')[0];
        break;
      }
    }
    // default pet
    return PetModels.getPetWidget(petName);
  }

 
}
