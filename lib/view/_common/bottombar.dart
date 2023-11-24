import 'package:flutter/material.dart';

class MyBottomNav extends StatelessWidget implements PreferredSizeWidget {
  const MyBottomNav({super.key});
// TODO : size 변경해야 함.
  @override
  Size get preferredSize => Size.fromHeight(52);

// TODO : 다른 페이지 라우팅은 여기서!
// 이미 home인디 Home 으로 이동하는 경우는 아무것도 하지않도록 하는 코드 추가 필요
  void goHome(context, uri) {
    switch (uri) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (Route<dynamic> route) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
            context, "/group", (Route<dynamic> route) => false);
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(
            context,
            "/myroom",
            arguments: true,
            (Route<dynamic> route) => false);
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(
            context, '/mypage', (Route<dynamic> route) => false);
      default:
        Navigator.pushNamedAndRemoveUntil(
            context, '/landing', (Route<dynamic> route) => false);
      // throw UnimplementedError('no widget for uri $uri');
    }
  }

  // 무조건 있어야함!
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        selectedItemColor: Colors.blue.shade500,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false, //  이 옵션 주면 라벨 text 뜨지않음
        showUnselectedLabels: false,
        onTap: (i) {
          goHome(context, i);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outlined), label: "할일"),
          BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined), label: "그룹"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "마이룸"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "상점"),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity_outlined), label: "마이페이지"),
        ]);
  }
}