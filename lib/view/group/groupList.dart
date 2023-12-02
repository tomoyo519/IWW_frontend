import 'package:flutter/material.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:lottie/lottie.dart';

class GroupList extends StatelessWidget {
  GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MyGroupViewModel>();
    final myGroups = viewModel.groups;
    return Column(children: [
      viewModel.iswait
          ? Expanded(
              child: Container(
                child: Lottie.asset('assets/spinner.json',
                    repeat: true,
                    animate: true,
                    height: MediaQuery.of(context).size.height * 0.3),
              ),
            )
          : myGroups.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: myGroups.length,
                      itemBuilder: (c, i) {
                        return TextButton(
                            onPressed: () => Navigator.pushNamed(
                                context, "/group/detail",
                                arguments: myGroups[i]),
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.black26, width: 1)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, //
                                    children: [
                                      Text(
                                        myGroups[i].grpName,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        myGroups[i].grpDesc ?? "그룹에 대한 설명입니다.",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        ' ${myGroups[i].catName}',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Text('멤버 ${myGroups[i].memCnt}명',
                                      style: TextStyle(fontSize: 13))
                                ],
                              ),
                            ));
                      }),
                )
              : Text("텅"),
    ]);
  }
}
