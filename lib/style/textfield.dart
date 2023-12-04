import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Function(String value) onchange;
  final String? label;
  final EdgeInsets? padding;
  final TextAlign? textAlign;

  const MyTextField({
    super.key,
    required this.onchange,
    this.label,
    this.padding,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    // * ==== styles ==== * //
    final fillColor = Colors.grey.shade200;
    final defaultBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 0,
        color: Colors.white,
      ),
      borderRadius: BorderRadius.circular(10),
    );

    return TextField(
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        contentPadding: padding,
        hintText: label ?? '',
        border: defaultBorder,
        enabledBorder: defaultBorder,
        focusedBorder: defaultBorder,
        focusColor: fillColor,
        fillColor: fillColor,
        filled: true,
      ),
      style: TextStyle(
        fontSize: 16,
      ),
      onChanged: onchange,
    );
  }
}
