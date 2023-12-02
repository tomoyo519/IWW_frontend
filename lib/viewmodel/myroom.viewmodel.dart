import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
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
  AssetImage getBackgroundImage() {
    for (var element in roomObjects) {
      if (element.itemType == 4) {
        return AssetImage('assets/bg/${element.path}');
      }
    }
    // default background
    return AssetImage('assets/bg/bg15.png');
  }

  Widget getPetWidget() {
    for (var element in roomObjects) {
      if (element.itemType == 1) {
        return ModelViewer(
          src: 'assets/pets/${element.path}',
          autoPlay: true,
          animationName: "walk",
          cameraOrbit: "40deg 55deg 0.4m",
          cameraTarget: "0.5m 0m 0m",
          interactionPrompt: InteractionPrompt.none,
          autoRotate: true,
          rotationPerSecond: "0.5rad",
        );
      }
    }
    // default pet
    return Text('No pet');
  }

  final Map<String, ModelViewer> _petModels = {
    'kitsune': ModelViewer(
      src: 'assets/pets/kitsune.glb',
      ar: true,
      disableZoom: true,
      autoPlay: true,
      interactionPrompt: InteractionPrompt.none,
      cameraControls: true,
      cameraOrbit: "40deg 55deg 0.4m",
      cameraTarget: "0.5m 0.5m 0.5m",
      shadowIntensity: 1,
      autoRotate: true,
      rotationPerSecond: "0.5rad",
    ),
  };
}
