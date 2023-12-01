import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:provider/provider.dart';

class MyRoomViewModel with ChangeNotifier {
  final int _userId;
  final RoomRepository _roomRepository;
  int roomOwner;
  List<Item> roomObjects = [];
  List<Item> inventory = [];


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
  String getBackgroundImagePath() {
    for (var element in roomObjects) {
      if (element.itemType == 4) {
        return element.path!;
      }
    }
    // default background
    return "";
  }

  String getPetPath() {
    for (var element in roomObjects) {
      if (element.itemType == 1) {
        return element.path!;
      }
    }
    // default pet
    return "";
  }

}
