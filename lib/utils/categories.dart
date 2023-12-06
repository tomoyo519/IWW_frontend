import 'package:flutter/material.dart';

class Category {
  final String name;
  String? path;
  String? image;
  Color? color;

  Category({
    required this.name,
    this.image,
    this.color,
    this.path,
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
    Category(
      name: "전체",
      color: Color(0xff8aa3af),
      path: "assets/category/etc.jpg",
    ),
    Category(
        name: "공부",
        color: Color(0xff91e62b),
        path: "assets/category/study.jpg"),
    Category(
        name: "운동",
        color: Color(0xffc067cb),
        path: "assets/category/exercise.jpg"),
    Category(
        name: "코딩",
        color: Color(0xff45eb14),
        path: "assets/category/coding.jpg"),
    Category(
        name: "게임", color: Color(0xffcb9007), path: "assets/category/game.jpg"),
    Category(
        name: "명상",
        color: Color(0xff140397),
        path: "assets/category/meditation.jpg"),
    Category(
        name: "모임",
        color: Color(0xffbc51e8),
        path: "assets/category/group.jpg"),
    Category(
        name: "학업",
        color: Color(0xff851bf5),
        path: "assets/category/academy.jpg"),
    Category(
        name: "자유시간",
        color: Color(0xfff305f7),
        path: "assets/category/freetime.jpg"),
    Category(
        name: "자기관리",
        color: Color(0xff5219a4),
        path: "assets/category/selfcontrol.jpg"),
    Category(
        name: "독서",
        color: Color(0xffe71d70),
        path: "assets/category/reading.jpg"),
    Category(
        name: "여행",
        color: Color(0xff8b4ae1),
        path: "assets/category/travel.jpg"),
    Category(
        name: "유튜브",
        color: Color(0xff2275aa),
        path: "assets/category/youtube.jpg"),
    Category(
        name: "약속",
        color: Color(0xff8e8d8c),
        path: "assets/category/appointment.jpg"),
    Category(
        name: "산책",
        color: Color(0xfffc49e0),
        path: "assets/category/walking.jpg"),
    Category(
        name: "집안일",
        color: Color(0xfffc56d3),
        path: "assets/category/housework.jpg"),
    Category(
        name: "취미",
        color: Color(0xffb93c04),
        path: "assets/category/hobby.jpg"),
    Category(
      name: "기타",
      color: Color(0xff0fc21c),
      path: "assets/category/기타.jpg",
    ),
  ];
}
