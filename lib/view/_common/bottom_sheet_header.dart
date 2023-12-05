// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

// 커스텀 Bottom Sheet Header
class BottomSheetModalHeader extends StatelessWidget {
  final void Function(BuildContext)? onSave;
  final void Function(BuildContext)? onCancel;
  final String? title;
  final Color? color;

  final double BORDER_RADIUS = 8;

  const BottomSheetModalHeader({
    super.key,
    this.title,
    this.onCancel,
    this.onSave,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(BORDER_RADIUS),
            topRight: Radius.circular(BORDER_RADIUS),
          ),
          color: color ?? Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (onCancel != null) ...[
              TextButton(
                  onPressed: () => onCancel!(context),
                  child: Text(
                    "취소",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ))
            ],
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (onSave != null) ...[
              TextButton(
                onPressed: () => onSave!(context),
                child: Text(
                  "저장",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
