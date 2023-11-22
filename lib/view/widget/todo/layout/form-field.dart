// 폼 필드 레이아웃
import 'package:flutter/material.dart';
import 'package:iww_frontend/style/colors.dart';

class TodoFormFieldLayout extends StatelessWidget {
  final IconData icon;
  final Widget child;

  TodoFormFieldLayout({
    super.key,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: MyColors.highlight,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
