import 'package:flutter/material.dart';

Future<Object?> showCustomFullScreenModal(
  BuildContext context,
  Widget child,
) {
  var screen = MediaQuery.of(context).size;
  return showGeneralDialog(
    context: context,
    pageBuilder: (
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return Material(
        child: Container(
          width: screen.width,
          height: screen.height,
          color: Colors.white,
          child: child,
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(
      context,
    ).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(
      milliseconds: 200,
    ),
  );
}
