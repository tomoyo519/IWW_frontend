import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/modals/todo_info_snanckbar.dart';

import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:provider/provider.dart';

import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:iww_frontend/view/todo/todo_editor.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/routine/routine.model.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  String groupName = '';
  String categoryName = '';
  String groupDesc = '';
  late GlobalKey<FormState> _formKey;
  List<Map<String, dynamic>> routine = [
    {
      "rout_name": "",
      "rout_desc": "",
      "rout_repeat": 1111111,
      "rout_srt": "",
      "rout_end": ""
    }
  ];

  setGroupName(String name) {
    setState(() {
      groupName = name;
    });
  }

  setCategoryName(String catName) {
    setState(() => categoryName = catName);
  }

  setGroupDesc(String desc) {
    setState(() {
      groupDesc = desc;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  // void _updateRoutine(BuildContext context) {
  //   final viewmodel = context.read<EditorModalViewModel>();

  //   LOG.log("Not implemented. ${viewmodel.hour}");
  //   Navigator.pop(context);
  // }

  _createGroup(BuildContext context) async {
    //새로운 그룹 만들기;
    final myGroupViewModel =
        Provider.of<MyGroupViewModel>(context, listen: false);

    final viewModel = context.read<MyGroupViewModel>();
    LOG.log('myGroupViewModel.groupData: ${myGroupViewModel.groupData}');
    LOG.log('groupName:$groupName');
    // TODO - userId 넣기
    await viewModel.createGroup().then((res) {
      if (res == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('그룹 생성이 완료 되었어요!'),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  void onCancel(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _onSave(BuildContext context) async {
    LOG.log("message");
    //저장누르면 루틴 추가하는 로직
    final editormodel = context.read<EditorModalViewModel>();
    bool result = await editormodel.createTodo();
    LOG.log("message $result");
    if (context.mounted && result == true) {
      // groupmodel.createTodo(data);
      Navigator.pop(context);
      showCustomSnackBar(
        context,
        text: "루틴 추가가 완료되었어요!",
        icon: Icon(
          Icons.ac_unit_outlined,
        ),
      );
    }
  }

  void _showTodoEditor(BuildContext context, Routine? routine) {
    final groupRepository =
        Provider.of<GroupRepository>(context, listen: false);
    final userInfo = Provider.of<UserInfo>(context, listen: false);
    Todo? todo = routine?.generateTodo(userInfo.user_id);
    MyGroupViewModel groupmodel = context.read<MyGroupViewModel>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => EditorModalViewModel(
            of: todo,
            user: userInfo,
            repository: groupmodel,
          ),
          child: EditorModal(
            init: todo,
            title: "루틴 추가",
            formKey: _formKey,
            onSave: (context) => _onSave(context),
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    );
  }

  // GlobalKey<FormState>를 초기화합니다.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final groupRepository =
        Provider.of<GroupRepository>(context, listen: false);

    final MyGroupViewModel viewModel = context.read<MyGroupViewModel>();
    return Scaffold(
        appBar: MyAppBar(),
        body: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(children: [
              TextField(
                onChanged: (value) {
                  viewModel.groupName = value;
                },
                decoration: InputDecoration(
                  hintText: "그룹명을 작성해주세요.",
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (c) {
                            return LabelListModal(
                              content: "label",
                              setLabel: (newLabel) {
                                Provider.of<MyGroupViewModel>(context,
                                        listen: false)
                                    .groupCat = (newLabel);
                              },
                            );
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      alignment: Alignment.center,
                      child: Text((viewModel.groupData['cat_id'] != null)
                          ? LabelListModal
                              .labels[(viewModel.groupData['cat_id'])]
                          : LabelListModal.labels[0]),
                    ),
                  ),
                ],
              ),
              TextField(
                onChanged: (value) {
                  viewModel.groupDesc = value;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 60),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                ),
              ),
              Text("기본 루틴"),
              Divider(color: Colors.grey, thickness: 1, indent: 10),
              Container(
                  child: TextButton(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.black26, width: 1)),
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Row(children: const [
                          Icon(Icons.add_outlined),
                          Text('그룹 루틴 추가 하기')
                        ]),
                      ),
                      onPressed: () {
                        _showTodoEditor(context, null);
                      })),
              Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF3A00E5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () {
                    _createGroup(context);
                    print('새로운 그룹 만들기');
                    // var result = http.post(Uri.parse(""))
                  },
                  child:
                      Text("새로운 그룹 만들기", style: TextStyle(color: Colors.white)),
                ),
              )
            ])));
  }
}
