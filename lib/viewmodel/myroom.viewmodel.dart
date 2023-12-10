import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/room.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/model/item/item.model.dart';

class MyRoomViewModel with ChangeNotifier {
// NOTE DB상의 펫 itemType은 1
  final itemTypeOfPet = 1;
  final itemTypeOfFurniture = 2;
  final itemTypeOfPetMotion = 3;
  final itemTypeOfBackground = 4;

  final RoomRepository _roomRepository;
  final int _userId; // 로그인한 사용자의 id
  List<Item> items = []; // 사용자의 인벤토리
  List<Item> pets = [];
  int _roomOwner; // 현재 있는 방의 주인 (기본값은 로그인한 사용자의 id)
  List<Item> roomObjects = []; // 현재 방에 존재하는 오브젝트 리스트
  List<Item> _initialRoomObjects = [];
  bool _hasChanges = false; // 현재 방에 변경사항이 있는지 여부

  MyRoomViewModel(this._userId, this._roomRepository, this._roomOwner) {
    fetchMyRoom(_roomOwner);
    fetchPet(_userId);
    fetchItem(_userId);
  }

  Future<void> fetchMyRoom(userId) async {
    roomObjects = await _roomRepository.getItemsOfMyRoom(userId);
    setInitialRoomObjects();
    notifyListeners();
  }

  Future<void> fetchPet(userId) async {
    pets = await _roomRepository.getPetsOfInventory(userId);
    notifyListeners();
  }

  Future<void> fetchItem(userId) async {
    items = await _roomRepository.getItemsOfInventory(userId);
    notifyListeners();
  }

  // 현재 viewModel의 roomObject를 DB에 저장
  Future<void> applyChanges() async {
    await _roomRepository.applyChanges(
        _userId, roomObjects.map((e) => e.id).toList());
    setInitialRoomObjects();
  }

  // 선택한 아이템을 myroom에 넣거나 빼는 함수
  void toggleItem(Item target) {
    for (Item now in roomObjects) {
      if (now.id == target.id) {
        // 펫과 배경화면은 삭제 불가능
        if (now.itemType == itemTypeOfPet ||
            now.itemType == itemTypeOfBackground) {
          return;
        }

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
    fetchMyRoom(userId);
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
    return AssetImage('assets/bg/bg21.png');
  }

  Widget renderRoomObjects(double height) {
    LOG.log('[RenderRoomObjects] 방에 있는 오브젝트 개수: ${roomObjects.length}');

    List<Widget> layers = [];
    // 2/3 step: 가구 추가
    for (int i = 0; i < roomObjects.length; i++) {
      Item element = roomObjects[i];
      if (element.itemType == 2) {
        layers.add(Positioned(
          top: height,
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
    for (var element in roomObjects) {
      if (element.itemType == itemTypeOfPet) {
        return element.name;
      }
    }
    LOG.log("NO PET MODEL. default: 구미호_01");
    return '구미호_01';
  }

  String findPetNickName() {
    // FIXME 본인 뿐만 아니라 다른사람의 펫 정보도 가져올 수 있어야 함.
    for (var element in roomObjects) {
      if (element.itemType == itemTypeOfPet) {
        return element.petName!;
      }
    }

    return '이름을 지어주세요!';
  }

  bool get hasChanges => _hasChanges;

  void setInitialRoomObjects() {
    _initialRoomObjects = List.from(roomObjects);
  }

  bool checkForChanges() {
    if (_initialRoomObjects.length != roomObjects.length) {
      return true;
    }

    for (var item in _initialRoomObjects) {
      if (!roomObjects.any((element) => element.id == item.id)) {
        return true;
      }
    }

    return false;
  }
}
