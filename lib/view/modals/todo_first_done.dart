import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TodoFirstDoneModal extends StatelessWidget {
  const TodoFirstDoneModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            // height: MediaQuery.of(buildContext).size.height * ,
            child: Lottie.asset(
              "assets/todo/coin.json",
              animate: true,
            ),
          ),
          Text(
            "+100",
            style: TextStyle(
              color: Colors.orange.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            "오늘의 첫 할일 달성!",
            style: TextStyle(
              // color: Colors.orange.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            "남은 할일도 달성해볼까요?",
            style: TextStyle(
              // color: Colors.orange.shade900,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("닫기"),
          )
        ],
      ),
    );
  }
}
