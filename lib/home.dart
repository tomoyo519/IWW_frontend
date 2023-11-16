import 'package:flutter/material.dart';
import 'appbar.dart';
import 'bottombar.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter/rendering.dart';

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
        ModelViewer(
          loading: Loading.eager,
          shadowIntensity: 1,
          src: 'assets/cat.glb',
          alt: 'A 3D model of an astronaut',
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
      // print('어떻게 사랑이 변하니');
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

class AddTodo extends StatelessWidget {
  const AddTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextButton(
      child: Text('내가보여?'),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Text('Hello, this is a modal bottom sheet'),
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
