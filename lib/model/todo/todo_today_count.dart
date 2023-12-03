class TodoTodayCount {
  final int todoTotal;
  final int todoDone;

  TodoTodayCount({
    required this.todoTotal,
    required this.todoDone,
  });

  factory TodoTodayCount.fromJson(Map<String, dynamic> body) {
    return TodoTodayCount(
      todoTotal: body['todo_today'],
      todoDone: body['todo_today_done'],
    );
  }
}
