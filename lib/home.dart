import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/add_todo.dart';
import 'package:iww_frontend/appbar.dart';
import 'package:iww_frontend/bottombar.dart';
import 'package:iww_frontend/pet.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calendar.dart';
import 'package:intl/intl.dart';
import 'listWidget.dart';
import 'package:provider/provider.dart';

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

class SelectedDate extends ChangeNotifier {
  String _selectedDate = '';
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

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          Expanded(child: Pet()),
          Expanded(
            child: ToDoList(),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}

class ToDoList extends StatefulWidget {
  ToDoList({super.key});
  var showAddTodo = false;

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  var scroll = ScrollController();
  final _formKey = GlobalKey<FormState>();
  var grpId;
  var label;
  List<dynamic> myTodoList = [];

  getData() async {
    // TODO - 환경변수로 domain 빼놓기, user_id 수정해야 함
    // TODO - 서버가 맛이 갔을때는 어떤 화면을 보여줘야 하는가?
    var result = await http
        .get(Uri.parse('http://yousayrun.store:8088/todo/user/${6}'))
        .catchError((error, stackTrace) {
      print(error);
      return null;
    });

    // ignore: unnecessary_null_comparison
    if (result == null) {
      print('웹요청중에 에러가 발생했습니다.');
      return;
    }

    setState(() {
      myTodoList = jsonDecode(result.body);
    });

    // TODO - 서버 맛 간경우
    // setState(() {
    //   myTodoList = ([
    //     {
    //       "todo_id": 3,
    //       "user_id": 1,
    //       "todo_name": "miracle evening으로 변경되었다!!",
    //       "todo_desc": "test",
    //       "todo_label": 2,
    //       "todo_date": "2023-11-20T10:33:23.959Z",
    //       "todo_done": true,
    //       "todo_start": "2023-11-20T10:33:23.959Z",
    //       "todo_end": "2023-11-20T10:33:24.959Z",
    //       "grp_id": null,
    //       "todo_img": null,
    //       "todo_deleted": false
    //     },
    //     {
    //       "todo_id": 3,
    //       "user_id": 1,
    //       "todo_name": "2miracle evening으로 변경되었다!!2",
    //       "todo_desc": "test",
    //       "todo_label": 2,
    //       "todo_date": "2023-11-20T10:33:23.959Z",
    //       "todo_done": true,
    //       "todo_start": "2023-11-20T10:33:23.959Z",
    //       "todo_end": "2023-11-20T10:33:24.959Z",
    //       "grp_id": null,
    //       "todo_img": null,
    //       "todo_deleted": false
    //     },
    //     {
    //       "todo_id": 3,
    //       "user_id": 1,
    //       "todo_name": "3miracle evening으로 변경되었다!!3",
    //       "todo_desc": "test",
    //       "todo_label": 2,
    //       "todo_date": "2023-11-20T10:33:23.959Z",
    //       "todo_done": true,
    //       "todo_start": "2023-11-20T10:33:23.959Z",
    //       "todo_end": "2023-11-20T10:33:24.959Z",
    //       "grp_id": null,
    //       "todo_img": null,
    //       "todo_deleted": false
    //     },
    //   ]);
    // });
  }

  deleteTodo() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('할일을 삭제하시겠어요?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('할일을 삭제할래요!'),
            isDestructiveAction: true,
            onPressed: () {
              // TODO - 할일 삭제
              print('옵션 1 선택');
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('취소'),
          isDefaultAction: true,
          onPressed: () {
            print('취소 선택');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  editTodo(info) {
// jsonDecode 필요 한지 체크해야됨,.
    print(info);
    String todoName = info["todo_name"];
    String desc = info["todo_desc"];
    var grpId = info["grp_id"];
    var label = info["todo_label"];
    Provider.of<SelectedDate>(context, listen: false)
        .setSelectedDate(info["todo_date"]);
    // TODO - todo_label 이 왜 etc로 되어있나...?
    // Provider.of<SelectedDate>(context, listen: false)
    //     .setSelectedLabel(info["todo_label"]);

    // todo 를 수정하는 화면에서 bottom modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Center(
            child: Builder(builder: (context) {
              return Column(
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
                              initialValue: todoName,
                              onChanged: (value) {
                                setState(() {
                                  todoName = value;
                                });
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                hintText: "수정할 할일 이름을 작성해 주세요.",
                                filled: false,
                                // enabledBorder: InputBorder.none,
                                focusColor: Color(0xFF3A00E5),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '수정할 할일 제목을 입력해 주세요!';
                                }
                                return null;
                              },
                            ),
                            Builder(builder: (context) {
                              return Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.calendar_today_outlined),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Calendar(
                                              setSelectedDay: (newDate) {
                                                Provider.of<SelectedDate>(
                                                        context,
                                                        listen: false)
                                                    .setSelectedDate(
                                                        newDate.toString());
                                              },
                                            );
                                          });
                                    },
                                  ),
                                  Consumer<SelectedDate>(
                                    builder: (context, selectedDate, child) {
                                      final format = DateFormat('yyyy년 M월 d일');
                                      DateTime dateTime = DateTime.parse(
                                          selectedDate.selectedDate);
                                      return Text(format.format(dateTime));
                                    },
                                  ),
                                ],
                              );
                            }),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (c) {
                                            return LabelList(
                                              content: "label",
                                              setLabel: (int newLabel) {
                                                Provider.of<SelectedDate>(
                                                        context,
                                                        listen: false)
                                                    .setSelectedLabel(newLabel);
                                              },
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.label_outline)),
                                Consumer<SelectedDate>(
                                  builder: (context, selectedDate, child) {
                                    return Text(
                                        labels[selectedDate.selectedLabel]);
                                  },
                                )
                                // Text(labels[label])
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.alarm_outlined),
                                  onPressed: () async {
                                    final TimeOfDay? selectedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );

                                    if (selectedTime != null) {
                                      Provider.of<SelectedDate>(context,
                                              listen: false)
                                          .setSelectedAlarmTime(selectedTime);
                                    }
                                  },
                                ),
                                Consumer<SelectedDate>(
                                  builder: (context, selectedDate, child) {
                                    String timeString =
                                        '${selectedDate.selectedAlarmTime.hour}시 ${selectedDate.selectedAlarmTime.minute}분';
                                    return Text(timeString.toString());
                                  },
                                )
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     IconButton(
                            //       icon: Icon(Icons.alarm_outlined),
                            //       onPressed: () {
                            //         Future<TimeOfDay?> selectedTime =
                            //             showTimePicker(
                            //           initialTime: TimeOfDay.now(),
                            //           context: context,
                            //         );
                            //         if (selectedTime != null) {}
                            //       },
                            //     ),
                            //     Consumer<SelectedDate>(
                            //       builder: (context, selectedDate, child) {
                            //         return Text(
                            //             '${selectedDate.selectedAlarmTime.toString()} 분 전 알림');
                            //       },
                            //     )
                            //   ],
                            // ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.star_outline),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (c) {
                                          return LabelList(
                                            content: "routine",
                                            setLabel: (newLabel) {
                                              Provider.of<SelectedDate>(context,
                                                      listen: false)
                                                  .setSelectedDate(
                                                      newLabel as String);
                                            },
                                          );
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
                                                TextFormField(
                                                  initialValue: desc,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      desc = value;
                                                    });
                                                  },
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var id = info["todo_id"];
                              String timeString =
                                  '${Provider.of<SelectedDate>(context, listen: false).selectedAlarmTime.hour}시 ${Provider.of<SelectedDate>(context, listen: false).selectedAlarmTime.minute}분';
                              var data = {
                                "user_id": 6,
                                "todo_name": todoName,
                                "todo_done": false,
                                "todo_desc": desc,
                                "todo_label": Provider.of<SelectedDate>(context,
                                        listen: false)
                                    .selectedLabel,
                                "todo_date": Provider.of<SelectedDate>(context,
                                        listen: false)
                                    .selectedDate,
                                "todo_start": timeString.toString(),
                              };
                              var json = jsonEncode(data);
                              var result = await http.put(
                                  Uri.parse(
                                      'http://yousayrun.store:8088/todo/${id}'),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: json);
                              print(result.body);
                            }
                          },
                          child: Text("변경하기",
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ]),
                  )
                ],
              );
            }),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getData();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        setState(() {
          widget.showAddTodo = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height / 2,
          child: ListView.builder(
              controller: scroll,
              itemCount: myTodoList.isNotEmpty ? myTodoList.length : 1,
              itemBuilder: (c, i) {
                return myTodoList.isNotEmpty
                    ? GestureDetector(
                        onLongPress: () {
                          //
                          print('길게 눌렀을떄,');
                          deleteTodo();
                        },
                        onTap: () {
                          print('그냥 짧게 눌렀을때,');
                          editTodo(myTodoList[i]);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.black26, width: 1)),
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                      value: false,
                                      onChanged: (c) {
                                        //TODO - onclick시 todo 완료 체크 해야함
                                      }),
                                  Text(myTodoList[i]["todo_name"]),
                                  myTodoList[i]["grp_id"] == null
                                      ? Icon(Icons.query_builder_outlined)
                                      : Icon(Icons.groups_outlined)
                                ])),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.black26, width: 1)),
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Text("아직 등록된 할 일이 없습니다. 등록해볼까요?"),
                      );
              }),
        ),
        // TODO - 실제파일 들어오면 버튼 위치 변경하기
        // if (widget.showAddTodo) AddTodo()
        AddTodo()
      ],
    );
  }
}
