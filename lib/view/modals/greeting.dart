import 'package:flutter/material.dart';

void showGreetingModal(BuildContext context) {
  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Container(
          height: 50,
          child: Card(
            child: Text("텍스트"),
          ),
        );
      });
}
