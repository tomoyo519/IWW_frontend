import 'package:flutter/material.dart';
import 'package:iww_frontend/view/appbar.dart';
import 'package:iww_frontend/view/label-list-modal.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  String groupName = '';
  String categoryName = '';
  String groupDesc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "그룹명을 작성해주세요.",
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (c) {
                            return LabelListModal(
                              content: "label",
                              setLabel: (newLabel) {
                                Provider.of<TodoViewModel>(context,
                                        listen: false)
                                    .setSelectedDate(newLabel as String);
                              },
                            );
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      alignment: Alignment.center,
                      child: Text("카테고리"),
                    ),
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 60),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                ),
              ),
              Text("기본 루틴"),
              Divider(color: Colors.grey, thickness: 1, indent: 10),
              Container(
                  child: TextButton(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black26, width: 1)),
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Row(children: const [
                    Icon(Icons.add_outlined),
                    Text('그룹 루틴 추가 하기')
                  ]),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(
                          child: Column(
                            children: [
                              Form(
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
                                              groupName = value;
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
                                                    color: Colors.black,
                                                    width: 1)),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return '새로운 작업을 추가해주세요!';
                                            }
                                            return null;
                                          },
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (c) {
                                                        return LabelListModal(
                                                            setLabel:
                                                                (newLabel) {
                                                              Provider.of<TodoViewModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .setSelectedDate(
                                                                      newLabel
                                                                          as String);
                                                            },
                                                            content: "label");
                                                      });
                                                },
                                                icon:
                                                    Icon(Icons.label_outline)),
                                            Text("라벨")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.alarm_outlined),
                                              onPressed: () {
                                                Future<TimeOfDay?>
                                                    selectedTime =
                                                    showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );
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
                                                      return LabelListModal(
                                                          setLabel: (newLabel) {
                                                            Provider.of<TodoViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .setSelectedDate(
                                                                    newLabel
                                                                        as String);
                                                          },
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
                                              icon: Icon(
                                                  Icons.sticky_note_2_outlined),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (c) {
                                                      return SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
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
                                                                child:
                                                                    Text("완료")),
                                                            TextField(
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  groupDesc =
                                                                      value;
                                                                });
                                                              },
                                                              maxLines: null,
                                                              decoration:
                                                                  InputDecoration(
                                                                border: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 40,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Color(0xFF3A00E5),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      onPressed: () {
                                        print('추가하기 버튼');
                                      },
                                      child: Text("추가하기",
                                          style:
                                              TextStyle(color: Colors.white)),
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
              )),
              Text("참가자"),
              Divider(color: Colors.grey, thickness: 1, indent: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: Text("정다희"))
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF3A00E5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () {
                    // joinGroup();
                    print('새로운 그룹 만들기');
                    // var result = http.post(Uri.parse(""))
                  },
                  child:
                      Text("새로운 그룹 만들기", style: TextStyle(color: Colors.white)),
                ),
              )
            ])));
  }
}
