// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/group/groupDetail.model.dart' as model;
import 'package:iww_frontend/model/routine/routine.model.dart';
import 'package:iww_frontend/model/todo/todo.model.dart';
import 'package:iww_frontend/model/group/groupImg.model.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:iww_frontend/service/event.service.dart';
import 'package:iww_frontend/style/button.dart';
import 'package:iww_frontend/style/button.type.dart';
import 'package:iww_frontend/utils/extension/string.ext.dart';
import 'package:iww_frontend/utils/weekdays.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'dart:convert';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/todo/todo_editor.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/todo_editor.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class GroupDetail extends StatefulWidget {
  final int groupId;
  final String? ownerName;

  final getList;
  GroupDetail({
    required this.getList,
    required this.groupId,
    required this.ownerName,
    super.key,
  });

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  model.GroupDetail? groupDetail;
  List<Routine> groupRoutine = [];
  List<dynamic> groupMems = [];

  bool myGroup = false;
  bool isLoading = true;

  List<Routine>? routines;
  List<GroupImg>? routineImgs;

  late File _imageFile;
  final _picker = ImagePicker();

  Future<void> getData() async {
    var result = await RemoteDataSource.get('/group/${widget.groupId}');
    var resultJson = jsonDecode(result.body);
    final userId = context.read<UserInfo>().userId;

    if (result.statusCode == 200) {
      var jsonResult = resultJson['result'];
      setState(() {
        // 비동기 로드 완료 후
        groupDetail = model.GroupDetail.fromJson(jsonResult['grp_detail']);
        List<dynamic> jsonRoutList = jsonResult["rout_detail"];
        groupRoutine = jsonRoutList
            .map((e) => Routine.fromGroupDetailJson(e, widget.groupId))
            .toList();

        groupMems = jsonResult["grp_mems"];

        if (groupMems.map((e) => e['user_id']).toList().contains(userId)) {
          myGroup = true;
        }

        // 로딩 상태를 완료로 변경
        isLoading = false;
      });
    }
  }

  joinGroup(grp_id) async {
    final userId = context.read<UserInfo>().userId;
    var data = jsonEncode({
      "user_id": userId,
      "grp_id": grp_id,
    });

    await RemoteDataSource.post("/group/$grp_id/join/${userId}", body: data)
        .then((res) async {
      if (res.statusCode == 201) {
        final viewModel = context.read<MyGroupViewModel>();
        await viewModel.fetchMyGroupList(userId);
        if (context.mounted) {
          await widget.getList();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: const Text("그룹 가입이 완료 되었어요!")));
          Navigator.pop(context);
        }
      }
    });
  }

  exitGroup(grp_id) async {
    final userId = context.read<UserInfo>().userId;
    var data = jsonEncode({
      "user_id": userId,
      "grp_id": grp_id,
    });
    await RemoteDataSource.delete("/group/$grp_id/left/${userId}", body: data)
        .then(
      (result) async {
        LOG.log("${result.body}, ${result.statusCode}");
        if (result.statusCode == 200) {
          final viewModel = context.read<MyGroupViewModel>();
          await viewModel.fetchMyGroupList(userId);
          if (context.mounted) {
            await widget.getList();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: const Text("그룹 탈퇴가 완료 되었어요!")));
            Navigator.pop(context);
          }
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text("그룹 탈퇴 실패했어요. 재시도 해주세요.")));
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  // TODO: 루틴 수정 시
  void _updateRoutine(BuildContext context) {
    final viewmodel = context.read<EditorModalViewModel>();

    LOG.log("Not implemented. ${viewmodel.hour}");
    Navigator.pop(context);
  }

  // 할일 수정
  void _showTodoEditor(BuildContext context, Routine? routine) {
    final userInfo = context.read<UserInfo>();
    final groupmodel = context.read<MyGroupViewModel>();
    Todo? todo = routine?.generateTodo(userInfo.userId);

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
            title: "루틴 수정",
            onSave: (context) => _updateRoutine(context),
            onCancel: (context) => Navigator.pop(context),
          ),
        );
      },
    );
  }

  void _setRoutinePicture(int routId) async {
    // 첫 번째 루틴 로드인 경우 상태 불러와서 세트
    if (routines == null) {
      await RemoteDataSource.get('/routine/${widget.groupId}').then((res) {
        if (res.statusCode == 200) {
          List<dynamic> jsonList = jsonDecode(res.body)['result'];
          setState(() {
            routines = jsonList
                .map((e) => Routine.fromJson(e, routId: routId))
                .toList();
          });
        }
      });
    }

    // 지금 보여주는 루틴 가져오기
    Routine? rout = routines?.where((e) => e.routId == routId).first;

    // 클릭시, 그룹 구성원의 사진 인증 보여주는 기능
    if (rout != null) {
      await RemoteDataSource.get("/group/${widget.groupId}/user/$routId/image")
          .then((res) {
        if (res.statusCode == 200) {
          var json = jsonDecode(res.body);
          LOG.log(res.body);
          setState(() {
            routineImgs = (json["result"] as List)
                .map((item) => GroupImg.fromJson(item))
                .toList();
          });
        }
        LOG.log('thisisroutineImgs: $routineImgs');
      });
    }
    // ignore: use_build_context_synchronously
    Size screen = MediaQuery.of(context).size;

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          height: screen.height * 0.8,
          width: screen.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: SizedBox(
                  height: screen.height * 0.15,
                  width: screen.width,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "인증 현황 보기",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      rout!.routRepeat.toWeekRepeat().name,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text("인증해요"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${routineImgs?.length ?? 0}건',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text("인증완료"),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              routineImgs!.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 각 행에 3개의 그리드 항목이 표시됩니다.
                          childAspectRatio: 1.0, // 그리드 항목의 가로세로 비율을 1:1로 설정합니다.
                        ),
                        itemCount: routineImgs?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.3,
                            margin: EdgeInsets.all(2),
                            padding: EdgeInsets.all(2),
                            child: Image.network(
                              '${Secrets.REMOTE_SERVER_URL}/group-image/${routineImgs![index].todoImg}',
                              // 이미지가 부모 위젯의 크기에 맞게 조절되도록 합니다.
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Lottie.asset('assets/empty.json',
                          repeat: true,
                          animate: true,
                          height: MediaQuery.of(context).size.height * 0.3)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppNavigator nav = context.read<AppNavigator>();
    Size screen = MediaQuery.of(context).size;
    UserInfo userInfo = context.read<UserInfo>();
    return !isLoading && groupDetail != null
        ? Scaffold(
            appBar: MyAppBar(),
            body: SingleChildScrollView(
              child: Column(children: [
                // 1. 상단 이미지
                ConstrainedBox(
                  constraints: BoxConstraints.expand(
                    height: screen.height * 0.25,
                  ),
                  child: Image.asset(
                    'assets/category/${groupDetail!.catImg}',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/category/academy.jpg',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),

                // 2. 그룹 제목
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      groupDetail!.grpName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                // 3. 그룹 운영자
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Text(
                          "그룹장",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              alignment: Alignment.centerRight, // 왼쪽 정렬
                              child: Text(
                                widget.ownerName ?? '운영자',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. 카테고리
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: Text(
                            "카테고리 ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 171, 169, 169)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(groupDetail!.catName,
                                        style:
                                            TextStyle(color: Colors.grey[800])),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 5. 그룹 설명
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "그룹 세부 정보",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(),
                        child: Text(
                          groupDetail!.grpDesc,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: Colors.grey[200],
                  thickness: 10,
                  height: 30,
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "기본 루틴",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: groupRoutine.length,
                      itemBuilder: (c, i) {
                        WeekRepeat repeat =
                            groupRoutine[i].routRepeat.toWeekRepeat();

                        return groupRoutine.isNotEmpty
                            ? Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.black26, width: 1),
                                ),
                                child: Stack(
                                  children: [
                                    myGroup == true // 내가 가입한 그룹인 경우 수정버튼 표시
                                        ? Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                              style: IconButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                padding: EdgeInsets.all(0),
                                              ),
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () => _showTodoEditor(
                                                  context, groupRoutine[i]),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    Column(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: 50,
                                            minWidth: double.infinity,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                groupRoutine[i].routName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  _RoutineBadge(
                                                    content:
                                                        '${repeat.name} 반복',
                                                  ),
                                                  if (repeat.count != 7) ...[
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    _RoutineBadge(
                                                      content: repeat.weekday
                                                          .map((e) => e.name)
                                                          .join('・')
                                                          .toString(),
                                                    ),
                                                  ]
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: MyButton(
                                                type: MyButtonType.primary,
                                                text: "인증 현황 보기",
                                                onpressed: (context) =>
                                                    _setRoutinePicture(
                                                        groupRoutine[i].routId),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: 10,
                                            // ),
                                            // Expanded(
                                            //   child: MyButton(
                                            //     type: MyButtonType.primary,
                                            //     text:
                                            //         "인증하기", // TODO: 실제 정보가 아닙니다.
                                            //     onpressed: (context) =>
                                            //         _onGrpRoutCheck(
                                            //       context,
                                            //       groupRoutine[i].grpId,
                                            //       userInfo.userId,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                            : Text("조회된 그룹이 없습니다.");
                      },
                    ),
                  ),
                ),

                Divider(
                  thickness: 10,
                  height: 30,
                  color: Colors.black12,
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const <Widget>[
                          Text(
                            "참가자",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2), // Container 위젯의 padding 속성 사용
                        alignment:
                            Alignment.center, // Container 위젯의 alignment 속성 사용
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color.fromARGB(255, 171, 169, 169)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "${groupMems.length}명",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     // 스타일 설정 추가
                      //     backgroundColor: Colors.orange, // 버튼 배경색을 오렌지색으로 설정
                      //   ),
                      //   onPressed: () {},
                      //   child: Container(
                      //   5,
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       '${groupMems.length}명',
                      //       style:
                      //           TextStyle(color: Colors.white), // 글자색을 흰색으로 설정
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2 / 1, crossAxisCount: 3),
                        itemCount: groupMems.isEmpty ? 0 : groupMems.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              // 사용자 화면으로 이동해야 합니다.
                              final assetsAudioPlayer = AssetsAudioPlayer();
                              assetsAudioPlayer.open(Audio("assets/main.mp3"));
                              assetsAudioPlayer.play();
                              nav.push(AppRoute.room,
                                  argument:
                                      groupMems[index]["user_id"].toString());
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.account_circle_rounded),
                                      Text(
                                        groupMems[index]["user_name"] ?? "",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                if (!myGroup) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF3A00E5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onPressed: () async {
                          final assetsAudioPlayer = AssetsAudioPlayer();
                          assetsAudioPlayer.open(Audio("assets/main.mp3"));
                          assetsAudioPlayer.play();
                          await joinGroup(widget.groupId);
                        },
                        child:
                            Text("참가하기", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ],
                if (myGroup) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF3A00E5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onPressed: () async {
                          final assetsAudioPlayer = AssetsAudioPlayer();
                          assetsAudioPlayer.open(Audio("assets/main.mp3"));
                          assetsAudioPlayer.play();
                          await exitGroup(widget.groupId);
                        },
                        child:
                            Text("탈퇴하기", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ]
              ]),
            ))
        : Lottie.asset('assets/spinner.json',
            repeat: true,
            animate: true,
            height: MediaQuery.of(context).size.height * 0.3);
  }

  // 그룹 사진 업로드
  Future<void> _onGrpRoutCheck(
      BuildContext context, int routId, int userId) async {
    // 체크가 되어있지 않은 todo를 사진전송 하고 완료 처리 하는 경우,
    final pickedFile = await _picker
        .pickImage(source: ImageSource.camera)
        .onError((error, stackTrace) {
      // 사용자가 권한거부하여 picker 창이 종료된 경우
      LOG.log("Error while opening image picker! $error");
      return null;
    });

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        LOG.log("image file ${_imageFile.toString()}");
      });
      final formatter = DateFormat('yyyy-MM-dd');
      final formattedDate = formatter.format(DateTime.now());

      if (context.mounted) {
        // * ==== 사진 확인 및 할일 완료 모달 ==== * //
        bool? saved = await showGeneralDialog(
          context: context,
          pageBuilder: (
            BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    '할일 완료!',
                    style: TextStyle(
                      // 여기에서 스타일을 적용합니다.
                      fontSize: 16, // 글자 크기
                      color: Colors.white, // 글자 색상
                      fontWeight: FontWeight.w500, // 글자 두께
                    ),
                  ),
                  onPressed: () async {
                    // * ==== 버튼 눌렀을때의 로직 ==== * //
                    var image = File(pickedFile.path);
                    await RemoteDataSource.patchFormData(
                            "/group/todo/$routId/user/$userId/image", 'file',
                            file: image, filename: pickedFile.path)
                        .then((res) {
                      if (res.statusCode == 200) {}
                    }).catchError((err) {
                      LOG.log('Error sending image');
                    });
                    // 여기서 todoId 찾기??
                    var data = {
                      'userId': userId,
                      'routId': routId,
                    };

                    EventService.sendEvent('routineConfirmRequest', data);
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                )
              ],
              content: Expanded(
                  child: Stack(
                children: [
                  Image.file(_imageFile),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.black.withOpacity(0.5),
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            );
          },
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 300),
        );
      }
    }
  }
}

class _RoutineBadge extends StatelessWidget {
  const _RoutineBadge({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        // 비트로 체크된 루틴 반복날짜를 스트링으로 변환
        content,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
