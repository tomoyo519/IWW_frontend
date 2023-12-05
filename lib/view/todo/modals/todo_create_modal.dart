// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iww_frontend/main.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/todo_modal.viewmodel.dart';
import 'package:provider/provider.dart';

class TodoCreateModal extends StatelessWidget {
  final String? title;
  final FocusNode focusNode;
  final TextEditingController controller;
  final double keyboardHeight;

  TodoCreateModal({
    super.key,
    this.title,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        viewmodel.name = value;
                      },
                      focusNode: focusNode,
                      controller: controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "할일",
                        border: _getBorder(),
                        enabledBorder: _getBorder(),
                        focusedBorder: _getBorder(),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        viewmodel.desc = value;
                      },
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "설명을 입력하세요..",
                        border: _getBorder(),
                        enabledBorder: _getBorder(),
                        focusedBorder: _getBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          // vertical: 5,
                          horizontal: 10,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 70,
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
                    ]
                  ],
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

  List<int> HOURS = [for (int i = 1; i <= 12; i++) i];
  List<int> MINS = [for (int i = 0; i <= 60; i += 15) i];

  @override
  Widget build(BuildContext context) {
    return VerticalTimePicker();
  }
}

class _LabelPicker extends StatelessWidget {
  const _LabelPicker();

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<TodoModalViewModel>();
    return Wrap(
      children: [
        for (int idx = 0; idx < viewmodel.LABELS.length; idx++)
          TextButton(
            onPressed: () => viewmodel.label = idx,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(viewmodel.LABELS[idx]),
            ),
          )
      ],
    );
  }
}

class VerticalTimePicker extends StatefulWidget {
  @override
  _VerticalTimePickerState createState() => _VerticalTimePickerState();
}

class _VerticalTimePickerState extends State<VerticalTimePicker> {
  List<String> ampm = ['오전', '오후'];
  int _type = 0;
  int _hour = 0;
  int _minute = 0;

  void _updateTime(DragUpdateDetails details) {
    setState(() {
      _minute += details.delta.dy.round();
      if (_minute < 0) {
        _hour--;
        _minute = 59;
      } else if (_minute > 59) {
        _hour++;
        _minute = 0;
      }

      if (_hour < 0) {
        _hour = 23;
      } else if (_hour > 23) {
        _hour = 0;
      }
    });
  }

  void _updateHour(DragUpdateDetails details) {
    setState(() {
      _hour += details.delta.dy.round();
      if (_hour < 0) {
        _hour = 23;
      } else if (_hour > 23) {
        _hour = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onVerticalDragUpdate: _updateTime,
          child: Expanded(
            child: Center(
              child: Text('오전'),
            ),
          ),
        ),
        GestureDetector(
          onVerticalDragUpdate: _updateHour,
          child: Expanded(
            flex: 33,
            child: Center(
              child: Text('$_hour'),
            ),
          ),
        ),
        GestureDetector(
          onVerticalDragUpdate: _updateTime,
          child: Expanded(
            flex: 33,
            child: Center(
              child: Text('$_minute'),
            ),
          ),
        )
      ],
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
          horizontal: 15,
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
