import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/model/pet/pet_models.dart';
import 'package:iww_frontend/model/item/item.model.dart';

class MyRoomViewModel with ChangeNotifier {
// NOTE DB상의 펫 itemType은 1
  final itemTypeOfPet = 1;
  final itemTypeOfFurniture = 2;
  final itemTypeOfPetMotion = 3;
  final itemTypeOfBackground = 4;

  final RoomRepository _roomRepository;
  final int _userId; // 로그인한 사용자의 id
  List<Item> inventory = []; // 사용자의 인벤토리
  int _roomOwner; // 현재 있는 방의 주인 (기본값은 로그인한 사용자의 id)
  List<Item> roomObjects = []; // 현재 방에 존재하는 오브젝트 리스트

  MyRoomViewModel(this._userId, this._roomRepository, this._roomOwner) {
    fetchMyRoom();
    fetchInventory();
  }

  void fetchMyRoom() async {
    roomObjects = await _roomRepository.getItemsOfMyRoom(_roomOwner);
    notifyListeners();
  }

  void fetchInventory() async {
    inventory = await _roomRepository.getItemsOfInventory(_userId);
  }

  // 현재 viewModel의 roomObject를 DB에 저장
  Future<void> applyChanges() async {
    _roomRepository.applyChanges(
        _userId, roomObjects.map((e) => e.id).toList());
  }

  // 선택한 아이템을 myroom에 넣거나 빼는 함수
  void toggleItem(Item target) {
    for (Item now in roomObjects) {
      if (now.id == target.id) {
        roomObjects.remove(now);
        notifyListeners();
        return;
      }

      // 펫(type: 1)과 배경화면(type: 4)은 하나만 있어요
      if (now.itemType == target.itemType &&
          (target.itemType == itemTypeOfPet ||
              target.itemType == itemTypeOfBackground)) {
        LOG.log("펫과 배경화면은 하나만 있어요");
        roomObjects.remove(now);
        roomObjects.add(target);
        notifyListeners();
        return;
      }
    }
    
    // 중복되는 경우가 하나도 없을경우 -> 아이템 삽입
    roomObjects.add(target);
    notifyListeners();
  }

  get getRoomOwner => _roomOwner;

  set roomOwner(int userId) {
    _roomOwner = userId;
    fetchMyRoom();
    notifyListeners();
  }

  bool isMyRoom() => _userId == _roomOwner;

  /// itemType
  /// 1. pet
  /// 2. furniture
  /// 3. pet's motion
  /// 4. background
  AssetImage getBackgroundImage() {
    for (var element in roomObjects) {
      if (element.itemType == itemTypeOfBackground) {
        return AssetImage('assets/bg/${element.path}');
      }
    }
    LOG.log("NO BACKGROUND IMAGE. default: bg15.png");
    return AssetImage('assets/bg/bg15.png');
  }

  Widget renderRoomObjects(BuildContext context) {
    LOG.log('방에 있는 오브젝트 개수: ${roomObjects.length}');

    List<Widget> layers = [];
    // 2/3 step: 가구 추가
    for (int i = 0; i < roomObjects.length; i++) {
      var element = roomObjects[i];
      if (element.itemType == 2) {
        layers.add(Positioned(
          top: MediaQuery.of(context).size.height / 6.0,
          left: i * 100.0,
          width: 100,
          height: 100,
          child: Image.asset(
            'assets/furniture/${element.path}',
            fit: BoxFit.cover,
          ),
        ));
      }
    }

    LOG.log('방안의 가구 배치 완료');
    return Stack(
      alignment: Alignment.center,
      children: layers,
    );
  }

  String findPetName() {
    for (Item element in roomObjects) {
      if (element.itemType == itemTypeOfPet) {
        return element.name;
      }
    }

    // default pet
    return '구미호_02';
  } 
}
