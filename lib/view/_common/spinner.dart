import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Spinner extends StatelessWidget {
  const Spinner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Lottie.asset(
        'assets/spinner.json',
        repeat: true,
        animate: true,
        width: 50,
        height: 50,
      ),
    );
  }
}
