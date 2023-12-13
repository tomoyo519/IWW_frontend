import '/model/todo/todo.model.dart';

class Routine {
  int grpId;
  int routId;
  String routName;
  String routRepeat;

  String? routSrt;
  String? routEnd;
  String? routDesc;

  Routine({
    required this.routName,
    required this.grpId,
    required this.routId,
    required this.routRepeat,
    routDesc,
    routSrt,
    routEnd,
  });

  Map<String, dynamic> toJSON() {
    return {
      'rout_name': routName,
      'rout_desc': routDesc,
      'rout_repeat': routRepeat,
      'rout_srt': routSrt,
      'rout_end': routEnd,
    };
  }

  Routine.fromTodoJson(Map<String, dynamic> json)
      : routName = json['todo_name'],
        routDesc = json['todo_desc'],
        routRepeat = json['rout_repeat'] ?? '1111111',
        grpId = 0,
        routId = 0,
        routSrt = json['todo_start'],
        routEnd = json['todo_end'];

  Routine.fromJson(Map<String, dynamic> json, {int? routId})
      : routName = json['rout_name'] ?? json['todo_name'],
        routDesc = json['rout_desc'],
        routRepeat = json['rout_repeat'] ?? '1111111',
        grpId = json['grp_id'] ?? 0,
        routId = json['rout_id'] ?? routId ?? 0,
        routSrt = json['rout_srt'],
        routEnd = json['rout_end'];

  Routine.fromGroupDetailJson(Map<String, dynamic> json, this.grpId)
      : routId = json['rout_id'],
        routName = json['rout_name'],
        routDesc = json['rout_desc'],
        routRepeat = json['rout_repeat'] ?? '1111111',
        routSrt = json['rout_srt'],
        routEnd = json['rout_end'];

  // 오늘 날짜로 user_id를 매핑한 Todo를 생성해 반환한다.
  Todo generateTodo(int userId) {
    final Todo todo = Todo(
      todoId: 0, // DB에서 무시되어야 함
      grpId: grpId,
      userId: userId,
      todoName: routName,
      todoDesc: routDesc,
      todoStart: routSrt,
      todoEnd: routEnd,
    );

    return todo;
  }
}
