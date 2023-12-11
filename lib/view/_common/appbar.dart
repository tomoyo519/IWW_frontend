import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  // 무조건 있어야함!
  @override
  Widget build(BuildContext context) {
    final status = context.read<AuthService>().status;
    bool isUser = status == AuthStatus.initialized;

    int userCash = context.read<UserInfo>().userCash;
    String formattedCash = NumberFormat('#,###').format(userCash);

    Widget cash = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 1),
          child: Image.asset(
            'assets/cash.png',
            width: 55,
            height: 55,
          ),
        ),
        Text(
          formattedCash,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )
      ],
    );

    List<Widget> defaultAppbar = <Widget>[cash];

    if (actions != null) {
      defaultAppbar.addAll(actions!);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: AppBar(
        title: title,
        leading: leading,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: isUser
            ? defaultAppbar
                .map((e) => Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: e,
                    ))
                .toList()
            : null,
      ),
    );
  }
}
