import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iww_frontend/home.dart';
import 'package:provider/provider.dart';
import 'calendar.dart';
import 'listWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

final List<String> labels = [
  '운동',
  '식단',
  '회사업무',
  '가족행사',
  '저녁약속',
  '청첩장모임',
  '루틴',
  '개발공부'
];

class NewTodo extends ChangeNotifier {
  String _selectedDate = DateTime.now().toString();
  var _selectedLabel = 0;
  TimeOfDay _selectedAlarmTime = TimeOfDay.now();
  String get selectedDate => _selectedDate;
  int get selectedLabel => _selectedLabel;
  TimeOfDay get selectedAlarmTime => _selectedAlarmTime;

  void setSelectedDate(String newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  void setSelectedLabel(int labelNo) {
    _selectedLabel = labelNo;
    notifyListeners();
  }

  void setSelectedAlarmTime(dynamic alarmTime) {
    _selectedAlarmTime = alarmTime;
    notifyListeners();
  }
}

class AddTodo extends StatefulWidget {
  AddTodo({required this.getData, super.key});
  Function getData;
  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  // TODO - form data 핸들링

  DateTime focusedDay = DateTime.now();
  var label = 0;
  String todoName = "";
  String desc = "";
  String todoTime = '';

  newTodo() async {
    // TODO - user_id 어떻게 처리할것가 ???
    var data = {
      "user_id": 6,
      "todo_name": todoName,
      "todo_done": false,
      "todo_desc": desc,
      "todo_label": label,
      "todo_date": Provider.of<NewTodo>(context, listen: false).selectedDate,
      "todo_start": todoTime,
    };
    var json = jsonEncode(data);
    // print(json);
    var result = await http
        .post(Uri.parse('http://yousayrun.store:8088/todo'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json)
        .catchError((error) {
      print(error);
    });
    if (result.statusCode == 201) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('할일 추가가 완료 되었어요!'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).popAndPushNamed('/');
                },
              ),
            ],
          );
        },
      );
    } else {
      print('서버 실패');
    }
    widget.getData();
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
        child: Row(children: [Icon(Icons.add_outlined), Text('할일추가 하기')]),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (c) {
                                              return Calendar(
                                                setSelectedDay: (newDate) {
                                                  Provider.of<NewTodo>(context,
                                                          listen: false)
                                                      .setSelectedDate(
                                                          newDate.toString());
                                                },
                                              );
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today_outlined),
                                          Consumer<NewTodo>(
                                            builder:
                                                (context, selectedDate, child) {
                                              // final format = DateFormat(
                                              //     'yyyy년 M월 d일'); // 문자열을 파싱하는 형식
                                              // DateTime dateTime = format
                                              //     .parse(selectedDate.selectedDate);
                                              return Text(selectedDate
                                                  .selectedDate
                                                  .toString());
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (c) {
                                                return LabelList(
                                                  content: "label",
                                                  setLabel: (int newLabel) {
                                                    Provider.of<NewTodo>(
                                                            context,
                                                            listen: false)
                                                        .setSelectedLabel(
                                                            newLabel);
                                                  },
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.label_outline),
                                            Consumer<NewTodo>(
                                              builder: (context, value, child) {
                                                return Text(labels[
                                                    value.selectedLabel]);
                                              },
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final TimeOfDay? selectedTime =
                                            await showTimePicker(
                                          initialTime: TimeOfDay.now(),
                                          context: context,
                                        );

                                        if (selectedTime != null) {
                                          Provider.of<SelectedDate>(context,
                                                  listen: false)
                                              .setSelectedAlarmTime(
                                                  selectedTime);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.alarm_outlined),
                                          Consumer<SelectedDate>(
                                            builder:
                                                (context, selectedDate, child) {
                                              String timeString =
                                                  '${selectedDate.selectedAlarmTime.hour}시 ${selectedDate.selectedAlarmTime.minute}분';
                                              return Text(
                                                  timeString.toString());
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (c) {
                                              return LabelList(
                                                  setLabel: (newLabel) {
                                                    Provider.of<SelectedDate>(
                                                            context,
                                                            listen: false)
                                                        .setSelectedDate(
                                                            newLabel as String);
                                                  },
                                                  content: "routine");
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.star_outline),
                                          Text("매일 반복")
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () {
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("완료")),
                                                    TextField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          desc = value;
                                                        });
                                                      },
                                                      maxLines: null,
                                                      decoration:
                                                          InputDecoration(
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
                                      child: Row(
                                        children: [
                                          Icon(Icons.sticky_note_2_outlined),
                                          Text("작업 설명 추가"),
                                        ],
                                      ),
                                    ),
                                  ),
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
