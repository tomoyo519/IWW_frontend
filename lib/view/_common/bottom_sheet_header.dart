// 커스텀 Bottom Sheet Header
import 'package:flutter/material.dart';
import 'package:iww_frontend/style/colors.dart';

class BottomSheetModalHeader extends StatelessWidget {
  final void Function(BuildContext)? onSave;
  final void Function(BuildContext)? onCancel;
  final String title;
  final Color? color;

  const BottomSheetModalHeader({
    super.key,
    required this.title,
    this.onCancel,
    this.onSave,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: color ?? MyColors.background,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            onCancel != null
                ? TextButton(
                    onPressed: () => onCancel!(context),
                    child: Text(
                      "취소",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ))
                : SizedBox(width: 0),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onSave != null
                ? TextButton(
                    onPressed: () => onSave!(context),
                    child: Text(
                      "저장",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ))
                : SizedBox(width: 0)
          ],
        ),
      ),
    );
  }
}