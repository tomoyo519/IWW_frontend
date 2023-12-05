import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/model/mypage/announcement.model.dart';

class Announcement extends StatefulWidget {
  const Announcement({super.key});

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  List<Announce> announces = [];
  @override
  void initState() {
    super.initState();
    setAnnounce();
  }

  setAnnounce() {
    var result = RemoteDataSource.get('/announcement').then((res) {
      if (res.statusCode == 200) {
        setState(() {
          announces = jsonDecode(res.body);
        });
      }
    }).catchError((err) {
      LOG.log(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(itemBuilder: (c, i) {
                    return Row(
                      children: [
                        Column(
                          children: [
                            announces.isEmpty
                                ? Expanded(
                                    child: Lottie.asset('assets/empty.json',
                                        repeat: true,
                                        animate: true,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3))
                                : Expanded(
                                    child: ListView.builder(
                                        itemCount: announces.length,
                                        itemBuilder: (c, i) {
                                          DateTime iso8601String =
                                              announces[i].regAt;
                                          String formattedString =
                                              "${iso8601String.year}년 ${iso8601String.month}월 ${iso8601String.day}일 ${iso8601String.hour}시 ${iso8601String.minute}분";
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(announces[i]
                                                      .title
                                                      .toString()),
                                                  Text(formattedString
                                                      .toString())
                                                ],
                                              )
                                            ],
                                          );
                                        })),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward_ios_outlined))
                          ],
                        )
                      ],
                    );
                  }),
                )
              ],
            )));
  }
}
