import 'package:flutter/material.dart';

void showCustomFullScreenModal({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  var screen = MediaQuery.of(context).size;
  showGeneralDialog(
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
          child: builder(context),
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
