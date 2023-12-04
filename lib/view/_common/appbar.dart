import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;

  const MyAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(50);

  // 무조건 있어야함!
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    );
  }
}
