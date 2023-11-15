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
          )
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
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  var scroll = ScrollController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   scroll.addListener(() { })
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height / 2,

        child: ListView.builder(
            itemCount: 80,
            itemBuilder: (c, i) {
              return Todo();
            }));
  }
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // padding: EdgeInsets.all(10),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(value: false, onChanged: (c) {}),
            Text("하루 30분 운동하기"),
            Icon(Icons.query_builder_outlined)
          ]),
    );
  }
}
