//
abstract class BaseTodoViewModel {
  Future<bool> createTodo(Map<String, dynamic> data);
  Future<bool> updateTodo(String id, Map<String, dynamic> data);
}
