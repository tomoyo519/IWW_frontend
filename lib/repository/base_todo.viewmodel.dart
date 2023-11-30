// EditorViewModel을 공용으로 쓰기위한
// 상위 ViewModel 인터페이스 정의
abstract class BaseTodoViewModel {
  Future<bool> createOne(Map<String, dynamic> data);
  Future<bool> updateOne(String id, Map<String, dynamic> data);
}
