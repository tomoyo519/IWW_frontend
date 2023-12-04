import 'dart:developer' as dev;

class LOG {
  static const _prefix = "IWW_DOWITH";
  LOG._internal();

  static void log(String message, {int? emoji}) {
    final stackTrace = StackTrace.current;
    final stackFrame = stackTrace.toString().split('\n')[1]; // 현재 위치의 스택 프레임

    // 파일명과 줄 수 파싱
    final locationPattern = RegExp(r'([^ ]*\.dart):(\d+):(\d+)');
    final match = locationPattern.firstMatch(stackFrame);
    final fileName = match?.group(1);
    final lineNumber = match?.group(2);

    var hearts = ["", "🤍 ", "💚 ", "💜 "];
    var show = (emoji == null || emoji > hearts.length - 1)
        ? hearts[0]
        : hearts[emoji];

    final logMessage = ("[$show$_prefix] [$fileName:$lineNumber] $message");

    dev.log(logMessage);
  }
}
