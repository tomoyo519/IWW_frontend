import 'package:flutter/material.dart';
import 'package:iww_frontend/style/app_theme.dart';

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
    double fs = MediaQuery.of(context).size.width * 0.01;

    return SizedBox(
      width: full == true ? double.infinity : null,
      child: ElevatedButton(
        onPressed: enabled == false ? null : () => onpressed(context),
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 4 * fs,
              color: txtColor,
              fontWeight: FontWeight.w900,
              fontFamily: AppTheme.FONT_FAMILY,
            ),
            foregroundColor: txtColor,
            backgroundColor: bgColor,
            padding: EdgeInsets.symmetric(
              horizontal: 3 * fs,
              vertical: 2 * fs,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3 * fs),
            )),
        child: Text(text),
      ),
    );
  }
}
