import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calendar.dart';
import 'listWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTodo extends StatefulWidget {
  AddTodo({super.key});
  DateTime? _selectedDay;

  DateTime _focusedDay = DateTime.now();
  var selectedMenu = "라벨";
  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  // TODO - form data 핸들링
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();
  var dropdownValue = '라벨을 선택해보세요!';
  bool isDescription = false;
  String todoName = "";
  String desc = "";
  newTodo() async {
    // var data = {
    //   "user_id": 1,
    //   "todo_name": todoName,
    //   "todo_done": false,
    //   "todo_desc": desc
    // };
    // var result = await http.post(Uri.parse('http://yousayrun.store:8088/todo'),
    //     body: data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextButton(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26, width: 1)),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Row(children: [Icon(Icons.add_outlined), Text('할일추가 하기?')]),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    todoName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[200],
                                  hintText: "새로운 작업을 추가합니다.",
                                  filled: false,
                                  // enabledBorder: InputBorder.none,
                                  focusColor: Color(0xFF3A00E5),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '새로운 작업을 추가해주세요!';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.alarm_outlined),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (c) {
                                            return Calendar();
                                          });
                                    },
                                  ),
                                  Text("오늘")
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (c) {
                                              return LabelList(
                                                  content: "label");
                                            });
                                      },
                                      icon: Icon(Icons.label_outline)),
                                  Text("라벨")
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.alarm_outlined),
                                    onPressed: () {
                                      Future<TimeOfDay?> selectedTime =
                                          showTimePicker(
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                      );
                                      if (selectedTime != null) {}
                                    },
                                  ),
                                  Text("시간 설정")
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.star_outline),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (c) {
                                            return LabelList(
                                                content: "routine");
                                          });
                                    },
                                  ),
                                  Text("매일 반복")
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.sticky_note_2_outlined),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (c) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: Column(
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("완료")),
                                                  TextField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        desc = value;
                                                      });
                                                    },
                                                    maxLines: null,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                  Text("작업 설명 추가"),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF3A00E5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                newTodo();
                              }
                            },
                            child: Text("추가하기",
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
