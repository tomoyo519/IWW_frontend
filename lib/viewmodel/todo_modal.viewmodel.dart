// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/utils/categories.dart';
import 'package:iww_frontend/utils/extension/string.ext.dart';
import 'package:iww_frontend/utils/extension/timeofday.ext.dart';
import 'package:iww_frontend/view/todo/modals/todo_create_modal.dart';
import 'package:iww_frontend/viewmodel/base_todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

class TodoModalViewModel<T extends ChangeNotifier> extends ChangeNotifier {
  final Todo? todo;
  late bool isNewTodo;
  final TodoModalMode mode;

  TodoModalViewModel({
    this.todo,
    required this.mode,
  }) : isNewTodo = todo == null {
    if (todo != null) {
      // 기존 투두를 수정하는 경우
      _todoName = todo!.todoName;
      _todoCate = todo!.todoLabel;
      _todoDesc = todo!.todoDesc;
      _todoDone = todo!.todoDone;

      _todoDate = todo!.todoDate.toDateTime();
      _todoSrt = todo!.todoStart.toTimeOfDay();
      _todoEnd = todo!.todoEnd.toTimeOfDay();

      _nameControl.text = _todoName!;
      _descControl.text = _todoDesc!;
    } else {
      // 새로운 투두를 생성하는 경우
      _todoCate = 0;
      _todoSrt = TimeOfDay.now();
      _todoDate = DateTime.now();
    }

    // 모달에 보여줄 필드 생성
    fields.add(cateField);
    fields.add(timeField);

    if (T is MyGroupViewModel) {
      fields.add(routField);
    }
  }

  // * === send request to create/update === * //\

  Future<bool> onSave(BuildContext context) async {
    final userId = context.read<UserInfo>().userId;
    final parent = Provider.of<T>(context, listen: false) as BaseTodoViewModel;
    final data = _createData(userId);

    return isNewTodo
        ? await parent.createTodo(data)
        : await parent.updateTodo(userId.toString(), data);
  }

  // * === pack status as request === * //
  Map<String, dynamic> _createData(int userId) {
    var data = {
      'user_id': userId,
      "todo_name": _todoName,
      "todo_desc": _todoDesc,
      "todo_label": _todoCate,
      "todo_done": _todoDone,
      "todo_start": _todoSrt.toDataString(),
      "todo_end": _todoEnd.toDataString(),
      "todo_deleted": false,
    };

    if (!isNewTodo) {
      // 투두 수정인 경우
      data['todo_id'] = todo!.todoId;
    }
    return data;
  }

  // * === 필드 목록 === * //
  // 1. 할일 이름
  String? _todoName;
  String? get name => _todoName;
  set name(String? val) {
    _todoName = val;
    notifyListeners();
  }

  // 2. 할일 설명
  String? _todoDesc;
  String? get desc => _todoDesc;
  set desc(String? val) {
    _todoDesc = val;
    notifyListeners();
  }

  // 3. 할일 카테고리
  int? _todoCate;
  int? get cate => _todoCate;
  set cate(int? val) {
    _todoCate = val;
    notifyListeners();
  }

  String get catName {
    return (_todoCate != null) ? cats[_todoCate!].name : cats[0].name;
  }

  // 4. 할일 완료여부
  bool? _todoDone;
  bool? get done => _todoDone;
  set done(bool? val) {
    _todoDone = val;
    notifyListeners();
  }

  // 5. 할일 시작시각
  TimeOfDay? _todoSrt;
  TimeOfDay? get todoSrt => _todoSrt;
  set todoSrt(TimeOfDay? val) {
    _todoSrt = val;
    notifyListeners();
  }

  // 6. 할일 종료시각
  TimeOfDay? _todoEnd;
  TimeOfDay? get todoEnd => _todoEnd;
  set todoEnd(TimeOfDay? val) {
    _todoEnd = val;
    notifyListeners();
  }

  // 7. 날짜 필드 (사용자가 수정 X)
  DateTime? _todoDate;
  DateTime? get todoDate => _todoDate;

  // * === check all fields exist === * //
  bool get isValid {
    return (_todoName != null && _todoName!.isNotEmpty) && (_todoCate != null);
  }

  // * === text controllers === * //
  final TextEditingController _nameControl = TextEditingController();
  final TextEditingController _descControl = TextEditingController();
  TextEditingController get nameControl => _nameControl;
  TextEditingController get descControl => _descControl;

  // * === visibility === * //
  int _option = -1;
  int get option => _option;
  set option(int val) {
    _option = val;
    notifyListeners();
  }

  // * ==== create button fields ==== * //
  List<ButtonFieldData> fields = [];

  ButtonFieldData cateField = ButtonFieldData(
    idx: 0,
    label: "라벨",
    icon: Icons.label_important_outline_rounded,
  );

  ButtonFieldData timeField = ButtonFieldData(
    idx: 1,
    label: "시간",
    icon: Icons.timer_outlined,
  );

  ButtonFieldData routField = ButtonFieldData(
    idx: 2,
    label: "반복",
    icon: Icons.repeat_rounded,
  );

  // * ==== common ==== * //
  List<Category> cats = Categories.categories;
}

class ButtonFieldData {
  final int idx;
  final String label;
  final IconData icon;

  ButtonFieldData({
    required this.idx,
    required this.label,
    required this.icon,
  });
}
