import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// 할일 상태 바
class TodoProgress extends StatelessWidget {
  TodoProgress({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now().add(Duration(hours: 9));
    final viewmodel = context.watch<TodoViewModel>();
    final usermodel = Provider.of<UserInfo>(context, listen: false);

    final cash = NumberFormat('#,##0').format(
      usermodel.user_money,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade400,
        ),
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
                "${viewmodel.check}/${viewmodel.total}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          Row(
            children: [
              viewmodel.total != 0
                  ? Expanded(
                      flex: viewmodel.check,
                      child: SizedBox(
                        height: 5,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                          color: Colors.orange,
                        )),
                      ),
                    )
                  : SizedBox.shrink(),
              Expanded(
                flex: (viewmodel.check + viewmodel.total),
                child: SizedBox(
                  height: 5,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(100),
                  )),
                ),
              ),
            ],
          )

          // Row(
          //   children: [
          //     SizedBox(
          //       width: 40,
          //       height: 40,
          //       child: IconButton.filled(
          //         onPressed: () => _onTap(context),
          //         style: IconButton.styleFrom(
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //             backgroundColor: Color.fromARGB(255, 255, 255, 255)),
          //         icon: Icon(
          //           Icons.add,
          //           color: Colors.blue.shade700,
          //           size: 25,
          //         ),
          //       ),
          //     )
          //   ],
          // )
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
