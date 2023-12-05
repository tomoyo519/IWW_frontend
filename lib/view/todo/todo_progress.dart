import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// 할일 상태 바
class TodoProgress extends StatelessWidget {
  TodoProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    DateTime today = DateTime.now().add(Duration(hours: 9));
    final model = context.watch<TodoViewModel>();
    final userinfo = context.watch<UserInfo>();

    final cash = NumberFormat('#,##0').format(
      userinfo.userCash,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.amber.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${model.todayDone}/${model.todayTotal}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${today.month}월 ${today.day}일",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              CashBadge(cash: cash)
            ],
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Column(
                  children: [
                    SizedBox(
                      // width: ,
                      child: Lottie.asset('assets/star.json'),
                    ),
                    Text("오늘 완료"),
                    Text("45"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CashBadge extends StatelessWidget {
  const CashBadge({
    super.key,
    required this.cash,
  });

  final String cash;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 25,
          height: 25,
          child: Lottie.asset(
            "assets/todo/coin.json",
            animate: false,
          ),
        ),
        Text(
          cash,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        )
      ],
    );
  }
}
