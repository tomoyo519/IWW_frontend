import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/utils/logger.dart';

class Category {
  final int id;
  final String name;
  String? path;

  Category({
    required this.id,
    required this.name,
    this.path,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['cat_name'],
      id: json['cat_id'],
    );
  }
}

class TodoCategory {
  static final TodoCategory _inst = TodoCategory._internal();
  TodoCategory._internal();

  static List<Category>? category;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized == true) return;

    await RemoteDataSource.get('/category').then((res) {
      LOG.log(res.body);
      if (res.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(res.body)['result'];
        category = jsonList.map((e) => Category.fromJson(e)).toList();

        Category etc = category!.removeLast(); // 전체그룹을 앞으로
        category!.insert(0, etc);
        _initialized = true;
      }
    });
  }
}
