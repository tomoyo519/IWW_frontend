// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/todo_modal.viewmodel.dart';
import 'package:provider/provider.dart';

enum TodoModalMode { normal, group }

class TodoCreateModal extends StatelessWidget {
  final TodoModalMode mode;
  final String? title;
  final FocusNode focusNode;
  final TextEditingController controller;
  final double keyboardHeight;

  TodoCreateModal({
    super.key,
    this.title,
    required this.mode,
    required this.controller,
    required this.focusNode,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<TodoModalViewModel>();
    final screen = MediaQuery.of(context).size;

    return WillPopScope(
      // 사용자의 뒤로가기 제어
      onWillPop: () async {
        LOG.log("입력을 취소하시겠습니까?");
        Navigator.of(context).pop();
        return true; // 기본 뒤로 가기 동작 방지
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screen.height * 0.9,
        ),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: keyboardHeight),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(BORDER_RADIUS),
                    topRight: Radius.circular(BORDER_RADIUS),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          viewmodel.name = value;
                        },
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        focusNode: focusNode,
                        controller: controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "할일을 입력하세요",
                          // border: _getBorder(),
                          enabledBorder: _getBorder(),
                          focusedBorder: _getBorder(),
                          contentPadding: EdgeInsets.only(
                            top: 20,
                          ),
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          viewmodel.desc = value;
                        },
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "설명",
                          border: _getBorder(),
                          enabledBorder: _getBorder(),
                          focusedBorder: _getBorder(),
                          contentPadding: EdgeInsets.only(
                            bottom: 5,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          bottom: 10,
                        ),
                        width: double.infinity,
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            for (var field in viewmodel.fields)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _ButtonField(
                                  onPressed: () {
                                    if (viewmodel.option < 0) {
                                      viewmodel.option = field.idx;
                                    } else {
                                      // toggle
                                      viewmodel.option = -1;
                                    }
                                  },
                                  text: getFieldData(field.idx, context) ??
                                      field.label,
                                  icon: field.icon,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (viewmodel.option >= 0) ...[
                        options[viewmodel.option](context),
                      ],
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.black12, width: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(DateFormat('M월 d일 E요일', 'ko_KR')
                                  .format(DateTime.now())),
                            ),
                            IconButton(
                              onPressed: viewmodel.isValid
                                  ? () => viewmodel.createNormal(context)
                                  : null,
                              icon: Icon(
                                Icons.send,
                                color: viewmodel.isValid
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // * ====== helpers ====== * //
  OutlineInputBorder _getBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color ?? Colors.white,
        width: 0,
      ),
    );
  }

  final double BORDER_RADIUS = 8;

  String? getFieldData(int idx, BuildContext context) {
    final viewmodel = context.read<TodoModalViewModel>();
    switch (idx) {
      case 0:
        return viewmodel.labelStr;
      case 1:
        return viewmodel.strtime;
      default:
        return "";
    }
  }

  List<WidgetBuilder> options = [
    (context) => _LabelPicker(),
    (context) => _TimePicker(),
  ];
}

// * ======================= * //
// *                         * //
// *     Picker Widgets      * //
// *                         * //
// * ======================= * //

class _TimePicker extends StatelessWidget {
  _TimePicker();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final viewmodel = context.read<TodoModalViewModel>();

    return SizedBox(
      width: screen.width,
      height: screen.height * 0.2,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: DateTime.now(),
        onDateTimeChanged: (value) {
          viewmodel.strtime = DateFormat('a HH시 mm분', 'ko_KR').format(value);
        },
      ),
    );
  }
}

class _LabelPicker extends StatelessWidget {
  const _LabelPicker();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final viewmodel = context.read<TodoModalViewModel>();

    return SizedBox(
      width: double.infinity,
      height: screen.height * 0.2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int idx = 0; idx < viewmodel.LABELS.length; idx++)
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              onPressed: () => viewmodel.label = idx,
              child: Text(viewmodel.LABELS[idx]),
            )
        ],
      ),
    );
  }
}

// * ======================= * //
// *                         * //
// *      Button Field       * //
// *                         * //
// * ======================= * //

class _ButtonField extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;

  const _ButtonField({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(8),
            side: BorderSide(
              color: Colors.black45,
              width: 0.5,
            )),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(text),
        ],
      ),
    );
  }
}
