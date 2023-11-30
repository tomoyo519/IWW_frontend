abstract class BaseTodoRepository {
  Future<bool> createOne(Map<String, dynamic> data);
  Future<bool> updateOne(String id, Map<String, dynamic> data);
}
