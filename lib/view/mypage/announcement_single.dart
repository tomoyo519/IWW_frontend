import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:lottie/lottie.dart';

class SingleAnnouncement extends StatefulWidget {
  var index;
  SingleAnnouncement({required this.index, super.key});

  @override
  State<SingleAnnouncement> createState() => _SingleAnnouncementState();
}

class _SingleAnnouncementState extends State<SingleAnnouncement> {
  var single;
  bool isLoading = true;
  late String formattedString;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSingle();
  }

  getSingle() {
    var result =
        RemoteDataSource.get('/announcement/${widget.index}').then((res) {
      LOG.log(res.statusCode.toString());
      if (res.statusCode == 200) {
        LOG.log(res.body);
        var json = jsonDecode(res.body);

        setState(() {
          single = json["result"];
          isLoading = false;
        });

        String iso8601String = json["result"]["reg_at"];
        DateTime dateTimeObject = DateTime.parse(iso8601String);
        String formatted =
            "${dateTimeObject.year}년 ${dateTimeObject.month}월 ${dateTimeObject.day}일 ${dateTimeObject.hour}시 ${dateTimeObject.minute}분";
        setState(() {
          formattedString = formatted;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
              child: Column(
            children: [
              isLoading == true
                  ? Expanded(
                      child: Lottie.asset('assets/spinner.json',
                          repeat: true,
                          animate: true,
                          height: MediaQuery.of(context).size.height * 0.3))
                  : single.isNotEmpty
                      ? Expanded(
                          child: Column(
                          children: [
                            Text(formattedString),
                            Text(
                              single["title"],
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            Image.network(
                                '${Secrets.REMOTE_SERVER_URL}' +
                                    '/' +
                                    single["anno_img"],
                                fit: BoxFit.cover),
                            Text(
                              single["content"],
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ))
                      : Expanded(
                          child: Lottie.asset('assets/empty.json',
                              repeat: true,
                              animate: true,
                              height: MediaQuery.of(context).size.height * 0.3))
            ],
          )),
        ));
  }
}
