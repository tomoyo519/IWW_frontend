import 'package:iww_frontend/model/room/room.model.dart';

class RoomRepository {
  Room _dummy = Room("1");

  // 특정 유저의 룸 정보 가져오기
  Future<Room?> getRoom(int userId) async {
    // _dummy
    return _dummy;
  }

  // 현재 유저의 룸 정보 수정
  Future<Room?> updateRoom(Room room) async {
    _dummy = room;
    return _dummy;
  }
}
