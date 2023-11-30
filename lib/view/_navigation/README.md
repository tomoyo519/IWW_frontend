# 플러터 페이지 내비게이션

Scaffold 형태를 사용하는 페이지는 모두 `lib/view/navigation/main_page.dart` 에서 인덱스 상태로 렌더링되도록 변경했습니다. 렌더링할 페이지 목록은 `lib/view/navigation/app_page.config.dart` 에서 가져옵니다.

```dart

// 단일 페이지 정보
class AppPage<T> {
  final String route;  // named route
  final String label;  // 페이지 이름
  final IconData icon; // 페이지 아이콘
  final ActionPage? float; // 플로팅버튼 정보
  final List<ActionPage>? appbar; // 앱바 액션 정보
  final T Function(BuildContext context) builder; // 빌드함수

  AppPage({
    required this.route,
    required this.label,
    required this.icon,
    required this.builder,
    this.float,
    this.appbar,
  });
}

// Appbar, FloatingActionButton 등
// Scaffold 서브위젯으로 내비게이팅되는 화면 정보
class ActionPage {
  final String route;  // named route
  final String label;  // 페이지 이름
  final IconData icon; // 페이지 아이콘

  ActionPage({
    required this.route,
    required this.label,
    required this.icon,
  });

  Widget toWidget(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon),
    );
  }
}
```
