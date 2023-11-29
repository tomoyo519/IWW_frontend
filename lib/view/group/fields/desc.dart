import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/bottom_sheet_header.dart';
import 'package:iww_frontend/view/todo/layout/form-field.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:provider/provider.dart';

class GroupDescField extends StatelessWidget {
  const GroupDescField({super.key});

  _onTap(BuildContext context) {
    final viewModel = Provider.of<MyGroupViewModel>(
      context,
      listen: false,
    );
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              BottomSheetModalHeader(
                title: "설명 추가",
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("완료")),
              TextFormField(
                initialValue: viewModel.groupData['grp_decs'] ?? "",
                onChanged: (value) => viewModel.groupData['grp_name'] = value,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: TodoFormFieldLayout(
        icon: Icons.sticky_note_2_outlined,
        child: Text("작업 설명 추가"),
      ),
    );
  }
}
