import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  // TODO: 외부에서 제목, 액션을 주입하게 변경
  final Widget? title;
  final List<Widget>? actions;

  const MyAppBar({Key? key, this.title, this.actions}) : super(key: key);
// T
  @override
  Size get preferredSize => Size.fromHeight(52);
  // 무조건 있어야함!
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    );
  }
}
