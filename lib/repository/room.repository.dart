import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/utils/logger.dart';

class RoomRepository {
// 특정 유저의 룸 정보 가져오기
  Future<List<Item>> getItemsOfMyRoom(int userId) async {
    return await RemoteDataSource.get('/room/$userId').then((response) {
      List<Item> items =
          (response.body as List).map((item) => Item.fromJson(item)).toList();
      LOG.log('Get room: ${response.statusCode}');
      LOG.log('items: ${response.body}');

      return items;
    });
  }
}
