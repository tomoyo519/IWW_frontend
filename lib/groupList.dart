import 'package:flutter/material.dart';
import 'package:iww_frontend/groupDetail.dart';
import 'groupDetail.dart';
import 'newGroup.dart';

class GroupList extends StatelessWidget {
  const GroupList({super.key});
  final List<dynamic> groups = const [
    {
      "grp_id": 1,
      "grp_name": "당신의 게으름 여기서 해결",
      "grp_decs": "게으름뱅이들의 모임",
      "owner": "이인복",
      "cat_id": 2,
      "cat_name": "공부",
      "mem_cnt": "6"
    },
    {
      "grp_id": 2,
      "grp_name": "Miracle Morning을 아십니까?",
      "grp_decs": "인증 필수 입니다.",
      "owner": "신병철",
      "cat_id": 4,
      "cat_name": "맛집 탐방",
      "mem_cnt": "5"
    },
    {
      "grp_id": 3,
      "grp_name": "과매기 팟 구함",
      "grp_decs": "제곧네",
      "owner": "박세준",
      "cat_id": 2,
      "cat_name": "공부",
      "mem_cnt": "4"
    },
    {
      "grp_id": 11,
      "grp_name": "등산 갑니다",
      "grp_decs": "매주 토요일 12시 등산 ㄱㄱ",
      "owner": "김지성",
      "cat_id": 3,
      "cat_name": "자기개발",
      "mem_cnt": "3"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (c, i) {
              return TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => GroupDetail(group: groups[i])));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          groups[i]["grp_name"],
                          style: TextStyle(color: Colors.black),
                        ),
                        Text('${groups[i]["mem_cnt"]}/100',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800))
                      ],
                    ),
                  ));
            }),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => NewGroup()));
          },
          child: Text("새로운 그룹 만들기", style: TextStyle(color: Colors.white)),
        ),
      )
    ]);
  }
}
