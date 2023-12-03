import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/modals/custom_snackbar.dart';

import 'package:iww_frontend/view/todo/fields/label_list_modal.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  _createGroup(BuildContext context) async {
    //새로운 그룹 만들기;

    final viewModel = context.read<MyGroupViewModel>();
    LOG.log('myGroupViewModel.groupData: ${viewModel.groups}');
    // LOG.log('groupName:$groupName');
    // TODO - userId 넣기
    await viewModel.createGroup().then(
      (res) async {
        LOG.log('thisisres: $res');
        if (res == true) {
          await viewModel.fetchMyGroupList();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('그룹 생성이 완료 되었어요!'),
              ),
            );
            Navigator.pop(context, true);
          }
        }
      },
    );
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
    UserInfo userInfo = Provider.of<UserInfo>(context, listen: false);
    Todo? todo = routine?.generateTodo(userInfo.userId);
    MyGroupViewModel groupmodel = context.read<MyGroupViewModel>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ChangeNotifierProvider(
          create: (_) => EditorModalViewModel(
            of: todo,
            user: userInfo,
            parent: groupmodel,
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

    UserInfo user = Provider.of<UserInfo>(context, listen: false);

    final MyGroupViewModel viewModel = context.watch<MyGroupViewModel>();
    return WillPopScope(
        onWillPop: () async {
          // 뒤로 가기 버튼을 눌렀을 때 동작을 여기에 코딩합니다.
          // 예를 들면 다이얼로그를 띄우거나 특정 함수를 실행하면 됩니다.

          // 이 함수는 Future<bool>를 반환해야 하며,
          // true를 반환하면 화면이 pop 됩니다.
          // false를 반환하면 화면이 pop 되지 않습니다.
          viewModel.groupRoutine = [];

          return Future.value(true);
        },
        child: Scaffold(
          appBar: MyAppBar(),
          body: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "그룹을 만들어주세요!",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "그룹 이름",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      viewModel.groupName = value;
                    },
                    decoration: InputDecoration(
                      hintText: "예) 1만보 걷기",
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                "카테고리 선택",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "그룹 세부 정보",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      viewModel.groupName = value;
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "예) 오늘 날짜와 걸음 가 가적힌 만보기 캡쳐 화면 업로드",
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "기본 루틴",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (viewModel.groupRoutine.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: viewModel.groupRoutine.length,
                            itemBuilder: (c, i) {
                              return GestureDetector(
                                onLongPress: () {
                                  _showTodoEditor(
                                      context, viewModel.groupRoutine[i]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.black26, width: 1)),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Checkbox(
                                          onChanged: null,
                                          value: false,
                                        ),
                                        Text(
                                            viewModel.groupRoutine[i].routName),
                                        Icon(Icons.groups_outlined)
                                      ]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF3A00E5),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: () {
                        _createGroup(context);
                        print('새로운 그룹 만들기');
                      },
                      child: Text("새로운 그룹 만들기",
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
