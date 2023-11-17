import 'package:flutter/material.dart';
import 'package:iww_frontend/appbar.dart';
import 'listWidget.dart';

class GroupDetail extends StatelessWidget {
  const GroupDetail({this.group, super.key});

  final group;
  @override
  Widget build(BuildContext context) {
    print(group["grp_name"]);
    return Scaffold(
        appBar: MyAppBar(),
        body: Container(
            child: Column(children: [
          Text(group["grp_name"]),
          TextButton(
            onPressed: () {},
            child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (c) {
                        return LabelList(content: "label");
                      });
                },
                icon: Icon(Icons.label_outline)),
          )
        ])));
  }
}
