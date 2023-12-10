import 'package:flutter/material.dart';

Future<Object?> showCustomFullScreenModal({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  var screen = MediaQuery.of(context).size;
  return showGeneralDialog(
    context: context,
    pageBuilder: (
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return Material(
        color: Colors.transparent,
        child: SizedBox(
          width: screen.width,
          height: screen.height,
          child: Center(child: builder(context)),
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Color.fromARGB(220, 0, 0, 0),
    transitionDuration: const Duration(
      milliseconds: 200,
    ),
  );
}
