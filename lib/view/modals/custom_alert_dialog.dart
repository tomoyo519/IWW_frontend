import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Object?> showCustomAlertDialog({
  required BuildContext context,
  required List<Widget>? actions,
  required Widget? content,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return AlertDialog(
        actions: actions,
        content: content,
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      );
    },
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 300),
  );
}
