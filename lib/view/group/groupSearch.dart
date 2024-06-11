import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/group/group.model.dart';
import 'package:iww_frontend/repository/group.repository.dart';
import 'package:iww_frontend/style/app_theme.dart';
import 'package:iww_frontend/utils/categories.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/group.viewmodel.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'groupDetail.dart';

class GroupSearch extends StatefulWidget {
  const GroupSearch({super.key});

  @override
  State<GroupSearch> createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  var labelNum = 0;
  String keyword = "";
  List<Group>? groupList = [];
  bool isClicked = false;
  bool isLoading = true;

  getList() async {
    final userInfo = context.read<UserInfo>();
    final groupRepository =
        Provider.of<GroupRepository>(context, listen: false);
    var tempList = await groupRepository.getAllGroupList(
        userInfo.userId, labelNum, keyword);

    setState(() {
      groupList = tempList;
    });
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  List<ChangeNotifierProvider> _groupDetailProviders(BuildContext context) {
    var userInfo = context.read<UserInfo>();
    return [
      ChangeNotifierProvider.value(value: context.read<UserInfo>()),
      ChangeNotifierProvider.value(value: context.read<MyGroupViewModel>()),
      ChangeNotifierProvider(
        create: (_) => GroupDetailModel(
            Provider.of<GroupRepository>(context, listen: false),
            userInfo.userId),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    LOG.log(labelNum.toString());
    return Container(
      child: Column(children: [
        Container(
            height: 60,
            padding: EdgeInsets.all(10),
            child: SearchBar(
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                  getList();
                },
                elevation: MaterialStateProperty.all(0),
                onSubmitted: (value) async {
                  final assetsAudioPlayer = AssetsAudioPlayer();
                  assetsAudioPlayer.open(Audio("assets/main.mp3"));
                  assetsAudioPlayer.play();
                  FocusManager.instance.primaryFocus?.unfocus();
                  getList();
                },
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 226, 225, 225)),
                // backgroundColor: Color(Colors.grey),
                hintText: "키워드 검색",
                hintStyle: MaterialStateProperty.all(TextStyle(fontSize: 20)),
                leading: Icon(Icons.search_outlined))),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 35,
                margin: EdgeInsets.all(1),
                padding: EdgeInsets.all(1),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: TodoCategory.category!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: labelNum == index
                              ? AppTheme.primary
                              : Colors.transparent, //회색으로, 그 외의 버튼은 흰색으로 변경
                          padding: EdgeInsets.all(2), // 패딩을 조절
                          elevation: 0, shape: StadiumBorder(), // 모서리를 완전히 둥글게
                        ),
                        onPressed: () async {
                          final assetsAudioPlayer = AssetsAudioPlayer();
                          assetsAudioPlayer.open(Audio("assets/main.mp3"));
                          assetsAudioPlayer.play();
                          setState(() {
                            labelNum = index;
                          });
                          getList();
                        },
                        child: Text(
                          TodoCategory.category![index].name,
                          style: TextStyle(
                            fontSize: 18,
                            color: labelNum == index
                                ? Colors.white
                                : Colors.black, // 클릭된 버튼의 배경색을 회색 글자색을 흰색으로 변경
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        isLoading
            ? Expanded(
                child: Lottie.asset('assets/spinner.json',
                    repeat: true,
                    animate: true,
                    height: MediaQuery.of(context).size.height * 0.3),
              )
            : groupList != null && groupList!.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: groupList!.length,
                        itemBuilder: (c, i) {
                          String picturePath =
                              'assets/category/${groupList![i].catImg}';
                          return TextButton(
                              onPressed: () async {
                                var userInfo = context.read<UserInfo>();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MultiProvider(
                                      // ==== 종속성 주입 ==== //
                                      providers: [
                                        ChangeNotifierProvider.value(
                                            value: context.read<UserInfo>()),
                                        ChangeNotifierProvider.value(
                                            value: context
                                                .read<MyGroupViewModel>()),
                                        ChangeNotifierProvider(
                                          create: (_) => GroupDetailModel(
                                              Provider.of<GroupRepository>(
                                                  context,
                                                  listen: false),
                                              userInfo.userId),
                                        )
                                      ],
                                      child: GroupDetail(
                                        getList: getList,
                                        groupId: groupList![i].groupId,
                                        ownerName: groupList![i].ownerName,
                                      ),
                                    ),
                                  ),
                                );
                                final assetsAudioPlayer = AssetsAudioPlayer();
                                assetsAudioPlayer
                                    .open(Audio("assets/main.mp3"));
                                assetsAudioPlayer.play();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(12),
                                //     border: Border.all(
                                //         color: Colors.black26, width: 1)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          20), // 원하는 border-radius 값으로 변경
                                      child: Image.asset(
                                        picturePath,
                                        fit: BoxFit
                                            .cover, // 이미지의 비율을 유지하면서 가능한 한 많은 공간을 차지하도록 합니다.
                                        width: 85,
                                        height: 85,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            10), // 필요에 따라 이미지와 텍스트 사이의 간격을 조절하세요
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(3),
                                              child: Text(
                                                groupList![i].grpName,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: AppTheme.font,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(3),
                                              child: Text(
                                                groupList![i].grpDesc ??
                                                    "그룹에 대한 설명입니다.",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(3),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              171, 169, 169)),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        '${groupList![i].catName}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      ' 멤버 ${groupList![i].memCnt}명',
                                                      style: TextStyle(
                                                          fontSize: 14))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }),
                  )
                : Expanded(
                    child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/empty.json',
                              repeat: true,
                              animate: true,
                              height: MediaQuery.of(context).size.height * 0.3),
                          Text(
                            "원하는 조건의 그룹이 없어요! \n 다른 키워드, 카테고리로 검색하거나 그룹을 만들 수 있어요.",
                            textAlign: TextAlign.center,
                          )
                        ]),
                  ))
      ]),
    );
  }
}
