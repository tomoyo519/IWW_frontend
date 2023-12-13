import 'package:flutter/material.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/utils/categories.dart';
import 'package:iww_frontend/view/todo/modals/todo_create_modal.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_modal.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

///** 투두 생성 모달을 보여주는 메소드
/// BaseTodoViewModel을 구현하는 클래스가
/// context 안에 존재하는 경우 사용 가능
/// */
void showTodoEditModal<T extends ChangeNotifier>(
  BuildContext context, {
  Todo? todo,
}) async {
  FocusNode focusNode = FocusNode();
  UserInfo userInfo = context.read<UserInfo>();
  T viewmodel = context.read<T>();

  TodoModalMode mode =
      T == MyGroupViewModel ? TodoModalMode.group : TodoModalMode.normal;

  await TodoCategory.initialize().then((_) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (c) {
        double keyboardHeight = MediaQuery.of(c).viewInsets.bottom;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: userInfo),
            ChangeNotifierProvider<T>.value(value: viewmodel),
            ChangeNotifierProvider(
                create: (_) => TodoModalViewModel<T>(
                      mode: mode,
                      todo: todo,
                    ))
          ],
          child: TodoCreateModal<T>(
            focusNode: focusNode,
            keyboardHeight: keyboardHeight,
          ),
        );
      },
    );
  });
}
