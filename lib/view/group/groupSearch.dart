import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'groupDetail.dart';

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

class GroupSearch extends StatefulWidget {
  const GroupSearch({super.key});

  @override
  State<GroupSearch> createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  var labelNum = 1;
  String keyword = "";
  List<dynamic> groupList = [];

  getList() async {
    //TODO - group_id/label_id/keyword
    var result = await http
        .get(Uri.parse(
            'http://yousayrun.store:8088/group/search/6/${labelNum}/${keyword}'))
        .catchError((err) {
      print(err);
      return null;
    });
    print(result.body);
    if (result.statusCode == 200) {
      setState(() {
        groupList = jsonDecode(result.body);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  letsSearch() {
    print('digh');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
            padding: EdgeInsets.all(20),
            child: SearchBar(
                onSubmitted: (value) {
                  letsSearch();
                },
                hintText: "키워드 검색",
                leading: Icon(Icons.search_outlined))),
        Row(
          children: [
            Expanded(
              child: Container(
                  height: 50,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: labels.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: FilledButton(
                              onPressed: () {}, child: Text(labels[index])));
                    },
                  )),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemCount: groupList.isNotEmpty ? groupList.length : 1,
              itemBuilder: (c, i) {
                return groupList.isNotEmpty
                    ? TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) =>
                                      GroupDetail(group: groupList[i])));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.black26, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                groupList[i]["grp_name"],
                                style: TextStyle(color: Colors.black),
                              ),
                              Text('${groupList[i]["mem_cnt"]}/100',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800))
                            ],
                          ),
                        ))
                    : Container(
                        child: Text('조회된 그룹이 없습니다.'),
                      );
              }),
        ),
      ]),
    );
  }
}
