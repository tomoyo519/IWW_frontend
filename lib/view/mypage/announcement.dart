import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/view/mypage/announcement_single.dart';
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
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    setAnnounce();
  }

  setAnnounce() async {
    var result = await RemoteDataSource.get('/announcement').then((res) {
      LOG.log(res.statusCode.toString());
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        if (json["result"] != null && json["result"].isNotEmpty) {
          List<Announce> result = (json["result"] as List)
              .map((item) => Announce.fromJson(item))
              .toList();
          setState(() {
            announces = result;
            isLoading = false;
          });
          LOG.log('thisis:announces $announces');
          LOG.log('thisis:isLoading $isLoading');
        }
      }
    }).catchError((err) {
      LOG.log(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    LOG.log('build에서의 announces, $announces');
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
                    isLoading == true
                        ? Expanded(
                            child: Lottie.asset('assets/spinner.json',
                                repeat: true,
                                animate: true,
                                height:
                                    MediaQuery.of(context).size.height * 0.3))
                        : announces.isNotEmpty
                            ? Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: ListView.builder(
                                            itemCount: announces.length,
                                            itemBuilder: (c, i) {
                                              LOG.log(i.toString());
                                              String iso8601String =
                                                  announces[i].regAt;
                                              DateTime dateTimeObject =
                                                  DateTime.parse(iso8601String);
                                              String formattedString =
                                                  "${dateTimeObject.year}년 ${dateTimeObject.month}월 ${dateTimeObject.day}일 ${dateTimeObject.hour}시 ${dateTimeObject.minute}분";
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        announces[i]
                                                            .title
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      Text(
                                                        formattedString
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SingleAnnouncement(
                                                                      index: announces[
                                                                              i]
                                                                          .annoId)),
                                                        );
                                                      },
                                                      icon: Icon(Icons
                                                          .arrow_forward_ios_outlined))
                                                ],
                                              );
                                            })),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: Lottie.asset('assets/empty.json',
                                    repeat: true,
                                    animate: true,
                                    height: MediaQuery.of(context).size.height *
                                        0.3))
                  ],
                )),
              ],
            )));
  }
}
