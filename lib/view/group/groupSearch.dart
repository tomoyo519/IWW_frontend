import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iww_frontend/utils/logger.dart';
import 'groupDetail.dart';
import 'package:lottie/lottie.dart';

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
            'http://yousayrun.store:8088/group/search/1/${labelNum}/${keyword}'))
        .catchError((err) {
      return null;
    });
    LOG.log(result.body);
    if (result.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(result.body);
      setState(() {
        List<dynamic> result = jsonData['results'];
        groupList = result;
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
        groupList.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: groupList.length,
                    itemBuilder: (c, i) {
                      return TextButton(
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
                                border: Border.all(
                                    color: Colors.black26, width: 1)),
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
                          ));
                    }),
              )
            : Lottie.asset('assets/spinner.json',
                repeat: true,
                animate: true,
                height: MediaQuery.of(context).size.height * 0.3)
      ]),
    );
  }
}
