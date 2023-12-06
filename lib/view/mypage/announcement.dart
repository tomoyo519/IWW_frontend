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
      LOG.log(res.body.toString());
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json["result"] != null && json["result"].isNotEmpty) {
          List<Announce> announces = (json["result"] as List)
              .map((item) => Announce.fromJson(item))
              .toList();
          setState(() {
            announces = announces;
          });
        }
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
                    child: Row(
                  children: [
                    announces.isEmpty
                        ? Expanded(
                            child: Lottie.asset('assets/empty.json',
                                repeat: true,
                                animate: true,
                                height:
                                    MediaQuery.of(context).size.height * 0.3))
                        : Column(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: announces.length,
                                      itemBuilder: (c, i) {
                                        String iso8601String =
                                            announces[i].regAt;
                                        DateTime dateTimeObject =
                                            DateTime.parse(iso8601String);
                                        String formattedString =
                                            "${dateTimeObject.year}년 ${dateTimeObject.month}월 ${dateTimeObject.day}일 ${dateTimeObject.hour}시 ${dateTimeObject.minute}분";
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(announces[i]
                                                    .title
                                                    .toString()),
                                                Text(formattedString.toString())
                                              ],
                                            )
                                          ],
                                        );
                                      })),
                              IconButton(
                                  onPressed: () {
                                    // TODO - 세부사항
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_outlined))
                            ],
                          )
                  ],
                )),
              ],
            )));
  }
}
