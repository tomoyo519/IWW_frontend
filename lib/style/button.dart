import 'package:flutter/material.dart';

import 'package:iww_frontend/style/button.style.dart';
import 'package:iww_frontend/style/button.type.dart';

class MyButton extends StatelessWidget {
  final String text;
  bool? full;
  MyButtonType? type;
  bool? enabled;
  void Function(BuildContext context) onpressed;

  MyButton({
    super.key,
    required this.text,
    required this.onpressed,
    this.enabled,
    this.type,
    this.full,
  }) {
    type = type ??
        (enabled != null && enabled == false
            ? MyButtonType.disabled
            : MyButtonType.primary);
    full = full ?? false;
    enabled = enabled ?? true;
  }

  @override
  Widget build(BuildContext context) {
    Color txtColor = type!.text();
    Color bgColor = type!.background();

    return SizedBox(
      width: full == true ? double.infinity : null,
      child: ElevatedButton(
        onPressed: enabled == false ? null : () => onpressed(context),
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: Text(
          text,
          style: TextStyle(
            color: txtColor,
          ),
        ),
      ),
    );
  }
}
