// 할일이 없는 경우 화면
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TodoListEmpty extends StatelessWidget {
  const TodoListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return SizedBox(
      width: screen.width * 0.8,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Lottie.asset(
              "assets/empty.json",
              animate: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: const [
                Text(
                  "오늘의 할 일이 없어요",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("+를 탭하여 할 일을 추가해볼까요?")
              ],
            ),
          )
        ],
      ),
    );
  }
}
