import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/group/groupDetail.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/view/_common/spinner.dart';
import 'package:iww_frontend/utils/logger.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MyGroupViewModel>();
    return Column(children: [
      Expanded(
        child: viewModel.waiting
            ? Spinner()
            : ListView.builder(
                itemCount: viewModel.groups.length,
                itemBuilder: (c, i) {
                  LOG.log('${viewModel.groups[i]}');
                  return viewModel.groups.isNotEmpty
                      ? TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => GroupDetail(
                                        group: viewModel.groups[i])));
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
                                  viewModel.groups[i].grpName,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text('${viewModel.groups[i].memCnt}/100',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800))
                              ],
                            ),
                          ))
                      : Text("no data");
                  // Lottie.asset('assets/spinner.json',
                  //     repeat: true,
                  //     animate: true,
                  //     height: MediaQuery.of(context).size.height * 0.3);
                }),
      ),
    ]);
  }
}
