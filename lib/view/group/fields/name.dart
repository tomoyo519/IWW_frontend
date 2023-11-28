import 'package:flutter/material.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';

// 할일 제목 필드
class GroupNameField extends StatelessWidget {
  const GroupNameField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 폼 필드 테두리 옵션
    final viewModel = context.read<MyGroupViewModel>();
    var borderOption = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    );

    return TextFormField(
      initialValue: viewModel.groupData['grp_name'],
      onChanged: (value) => viewModel.groupData['grp_name'] = value,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: "할일",
          filled: true,
          fillColor: MyColors.light,
          border: borderOption,
          focusedBorder: borderOption,
          errorBorder: borderOption,
          contentPadding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '수정할 할일 제목을 입력해 주세요!';
        }
        return null;
      },
    );
  }
}
