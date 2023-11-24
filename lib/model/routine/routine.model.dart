import '/model/todo/todo.model.dart';

class Routine {
  String routName;
  String routRepeat;
  int grpId;
  int routId;

  String? routDesc;
  String? routSrt;
  String? routEnd;

  Routine(
      {required this.routName,
      required this.routRepeat,
      required this.grpId,
      required this.routId,
      routDesc,
      routSrt,
      routEnd});

  Routine.fromJson(Map<String, dynamic> json)
      : routName = json['rout_name'],
        routDesc = json['rout_desc'],
        routRepeat = json['rout_repeat'],
        grpId = json['grp_id'],
        routId = json['rout_id'],
        routSrt = json['rout_srt'],
        routEnd = json['rout_end'];

  // 오늘 날짜로 user_id를 매핑한 Todo를 생성해 반환한다.
  Todo generateTodo(int userId) {
    final Todo todo = Todo(
      todoId: 0,
      userId: userId,
      todoName: routName,
      todoDesc: routDesc,
      todoStart: routSrt,
      todoEnd: routEnd,
      grpId: grpId,
    );

    return todo;
  }
}
