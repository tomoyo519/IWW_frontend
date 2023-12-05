import 'package:flutter/material.dart';

class Category {
  final String name;
  String? description;
  String? image;
  Color? color;

  Category({
    required this.name,
    this.image,
    this.color,
    this.description,
  });
}

// static final List<String> _routines = [
//   '매일',
//   '평일',
//   '주말',
//   '매주',
// ];

class Categories {
  static final Categories _inst = Categories();

  static List<Category> categories = [
    Category(name: "전체", color: Color(0xff8aa3af)),
    Category(name: "공부", color: Color(0xff91e62b)),
    Category(name: "운동", color: Color(0xffc067cb)),
    Category(name: "코딩", color: Color(0xff45eb14)),
    Category(name: "게임", color: Color(0xffcb9007)),
    Category(name: "명상", color: Color(0xff140397)),
    Category(name: "모임", color: Color(0xffbc51e8)),
    Category(name: "학업", color: Color(0xff851bf5)),
    Category(name: "자유시간", color: Color(0xfff305f7)),
    Category(name: "자기관리", color: Color(0xff5219a4)),
    Category(name: "독서", color: Color(0xffe71d70)),
    Category(name: "여행", color: Color(0xff8b4ae1)),
    Category(name: "유튜브", color: Color(0xff2275aa)),
    Category(name: "약속", color: Color(0xff8e8d8c)),
    Category(name: "산책", color: Color(0xfffc49e0)),
    Category(name: "집안일", color: Color(0xfffc56d3)),
    Category(name: "취미", color: Color(0xffb93c04)),
    Category(name: "기타", color: Color(0xff0fc21c)),
  ];
}
