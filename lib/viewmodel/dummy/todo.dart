import 'package:iww_frontend/model/todo/todo.model.dart';

class DummyData {
  static final _instance = DummyData._internal();
  DummyData._internal();

  static Future<List<Todo>> todoDummy() async {
    return [
      Todo.fromJson({
        "todo_id": 1,
        "user_id": 6,
        "todo_name": '새로운 투두 작성하는 테스트',
        "todo_desc": '회사일은 다 힘들지',
        "todo_label": 0,
        "todo_date": '2023-11-21',
        "todo_done": false,
        "todo_start": null,
        "todo_end": '00:00:00',
        "grp_id": null,
        "todo_img": "false",
        "todo_deleted": null,
      }),
      Todo.fromJson({
        "todo_id": 2,
        "user_id": 6,
        "todo_name": '새로운 투두 작성하는 테스트',
        "todo_desc": '회사일은 다 힘들지',
        "todo_label": 0,
        "todo_date": '2023-11-21',
        "todo_done": false,
        "todo_start": null,
        "todo_end": '00:00:00',
        "grp_id": null,
        "todo_img": "false",
        "todo_deleted": null,
      }),
      Todo.fromJson({
        "todo_id": 3,
        "user_id": 6,
        "todo_name": '새로운 투두 작성하는 테스트',
        "todo_desc": '회사일은 다 힘들지',
        "todo_label": 0,
        "todo_date": '2023-11-21',
        "todo_done": false,
        "todo_start": null,
        "todo_end": '00:00:00',
        "grp_id": null,
        "todo_img": null,
        "todo_deleted": null,
      }),
      Todo.fromJson({
        "todo_id": 4,
        "user_id": 6,
        "todo_name": '하하하',
        "todo_desc": '회사일은 다 힘들지',
        "todo_label": 0,
        "todo_date": '2023-11-21',
        "todo_done": false,
        "todo_start": null,
        "todo_end": '00:00:00',
        "grp_id": 1,
        "todo_img": "false",
        "todo_deleted": null,
      }),
      Todo.fromJson({
        "todo_id": 5,
        "user_id": 6,
        "todo_name": '하하하',
        "todo_desc": '회사일은 다 힘들지',
        "todo_label": 0,
        "todo_date": '2023-11-21',
        "todo_done": false,
        "todo_start": null,
        "todo_end": '00:00:00',
        "grp_id": null,
        "todo_img": null,
        "todo_deleted": null,
      }),
      Todo.fromJson({
        "todo_id": 6,
        "user_id": 6,
        "todo_name": '하하하',
        "todo_desc": '회사일은 다 힘들지',
        "todo_label": 0,
        "todo_date": '2023-11-21',
        "todo_done": false,
        "todo_start": null,
        "todo_end": '00:00:00',
        "grp_id": 1,
        "todo_img": null,
        "todo_deleted": null,
      }),
      Todo.fromJson({
        "todo_id": 7,
        "user_id": 6,
        "todo_name": '하하하',
        "todo_desc": '회사일은 다 힘들지',
        "todo_label": 0,
        "todo_date": '2023-11-21',
        "todo_done": false,
        "todo_start": null,
        "todo_end": '00:00:00',
        "grp_id": 1,
        "todo_img": null,
        "todo_deleted": null,
      })
    ];
  }
}
