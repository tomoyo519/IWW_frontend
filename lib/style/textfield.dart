import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Function(String value) onchange;
  final String? label;
  final EdgeInsets? padding;
  final TextAlign? textAlign;
  final bool? autofocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const MyTextField({
    super.key,
    required this.onchange,
    this.label,
    this.padding,
    this.textAlign,
    this.autofocus,
    this.focusNode,
    this.controller,
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
      // 텍스트 스타일
      style: TextStyle(
        fontSize: 16,
      ),
      // 박스 데코레이션
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        focusColor: fillColor,
        hintText: label ?? '',
        border: defaultBorder,
        enabledBorder: defaultBorder,
        focusedBorder: defaultBorder,
        contentPadding: padding,
      ),
      onChanged: onchange,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus ?? false,
    );
  }
}
