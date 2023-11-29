import 'package:flutter/material.dart';

Future<Object?> showCustomFullScreenModal(
  BuildContext context,
  Widget child,
) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.amber.shade50,
        child: SafeArea(
          child: child,
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(
      context,
    ).modalBarrierDismissLabel,
    // barrierColor: Colors.black45,
    transitionDuration: const Duration(
      milliseconds: 200,
    ),
  );
}
