import 'package:flutter/material.dart';
import 'package:iww_frontend/view/todo/modals/todo_create_modal.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_modal.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

///** 투두 생성 모달을 보여주는 메소드
/// BaseTodoViewModel을 구현하는 클래스가
/// context 안에 존재하는 경우 사용 가능
/// */
void showTodoCreateModal(BuildContext context) {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  UserInfo userInfo = context.read<UserInfo>();
  TodoViewModel viewmodel = context.read<TodoViewModel>();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (c) {
      double keyboardHeight = MediaQuery.of(c).viewInsets.bottom;

      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: userInfo),
          ChangeNotifierProvider.value(value: viewmodel),
          ChangeNotifierProvider(
              create: (_) => TodoModalViewModel(
                    mode: TodoModalMode.normal,
                  ))
        ],
        child: TodoCreateModal(
          focusNode: focusNode,
          controller: controller,
          keyboardHeight: keyboardHeight,
        ),
      );
    },
  );
}
