import 'package:flutter/material.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:lottie/lottie.dart';

// static method
void showTodoFirstDoneModal(BuildContext context) {
  showCustomFullScreenModal(
    context: context,
    builder: (context) => TodoFirstDoneModal(),
  );
}

class TodoFirstDoneModal extends StatelessWidget {
  const TodoFirstDoneModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Lottie.asset(
                    "assets/todo/coin.json",
                    animate: true,
                  ),
                  Text(
                    "+100",
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "오늘의 첫 할일 달성!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "남은 할일도 달성해볼까요?",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("닫기"),
            )
          ],
        ),
      ),
    );
  }
}
