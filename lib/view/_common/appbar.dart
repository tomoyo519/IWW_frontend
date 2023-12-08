import 'package:flutter/material.dart';
import 'package:iww_frontend/model/auth/auth_status.dart';
import 'package:iww_frontend/service/auth.service.dart';
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

    List<Widget> defaultAppbar = <Widget>[
      Row(
        children: [
          // 로그인된 페이지인 경우에만 캐시 노출
          if (isUser == true) ...[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Image.asset(
                'assets/cash.png',
                width: 25,
                height: 25,
              ),
            ),
            Text(context.read<UserInfo>().userCash.toString())
          ]
        ],
      ),
    ];

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
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: defaultAppbar,
      ),
    );
  }
}
