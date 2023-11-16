import 'package:flutter/material.dart';

import 'package:iww_frontend/add_todo.dart';
import 'package:iww_frontend/pet.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

enum SampleItem { itemOne, itemTwo, itemThree }

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Pet()),
          Expanded(
            child: ToDoList(),
          ),
        ],
      ),
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
  List myTodoList = [];
  getData() async {
    // TODO - 환경변수로 domain 빼놓기, user_id 수정해야 함
    var result =
        await http.get(Uri.parse('http://yousayrun.store:8088/todo/${1}'));

    if (result.statusCode == 200) {
      setState(() {
        myTodoList = jsonDecode(result.body);
      });
    } else {
      print('서버잘못임');
    }
  }

  @override
  void initState() {
    // Todo list 맨 마지막에 가면 '추가하기 버튼.

    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        setState(() {
          widget.showAddTodo = true;
        });
      }
    });
    getData();
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
              itemCount: myTodoList.isNotEmpty ? myTodoList.length : 0,
              itemBuilder: (c, i) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black26, width: 1)),
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: myTodoList.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Checkbox(value: false, onChanged: (c) {}),
                              Text(myTodoList[i]["todo_name"]),
                              myTodoList[i]["grp_id"] == null
                                  ? Icon(Icons.query_builder_outlined)
                                  : Icon(Icons.groups_outlined)
                            ])
                      : Container(),
                );
                ;
              }),
        ),
        // TODO - 실제파일 들어오면 버튼 위치 변경하기
        if (widget.showAddTodo) AddTodo()
      ],
    );
  }
}
