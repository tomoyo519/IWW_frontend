import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'appbar.dart';
import 'bottombar.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'listWidget.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

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

class Pet extends StatelessWidget {
  const Pet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        const ModelViewer(
          loading: Loading.eager,
          shadowIntensity: 1,
          src: 'assets/cat.glb',
          alt: 'cuttest pet ever',
          autoRotate: true,
          autoPlay: true,
          iosSrc: 'assets/cat2.usdz',
          disableZoom: true,
        ),
      ]),
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

  @override
  void initState() {
    // TODO: implement initState

    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        print('잡았다 요놈');
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
              itemCount: 10,
              itemBuilder: (c, i) {
                return Todo();
              }),
        ),
        // TODO - 실제파일 들어오면 버튼 위치 변경하기
        if (widget.showAddTodo) AddTodo()
      ],
    );
  }
}

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
                                      if (selectedTime != null) {
                                        print("시간설정완료 ${selectedTime}");
                                      }
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
                                                        Navigator.pop();
                                                      },
                                                      child: Text("완료")),
                                                  TextField(
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
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF3A00E5),
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')));
                            }
                          },
                          child: Text("추가하기",
                              style: TextStyle(color: Colors.white)),
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

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26, width: 1)),
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(value: false, onChanged: (c) {}),
            Text("하루 30분 운동하기"),
            Icon(Icons.query_builder_outlined)
          ]),
    );
  }
}
