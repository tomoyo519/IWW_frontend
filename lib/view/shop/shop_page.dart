import 'package:flutter/material.dart';
import 'package:iww_frontend/model/shop/shop.model.dart';
import 'package:iww_frontend/repository/shop.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/view/shop/layout/show_item.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShopItems();
  }
}

class ShopItems extends StatefulWidget {
  const ShopItems({super.key});
  @override
  State<ShopItems> createState() => _ShopItems();
}

class _ShopItems extends State<ShopItems> with SingleTickerProviderStateMixin {
  List<ShopInfo>? allpets;
  List<dynamic>? allfuns;
  List<dynamic>? allemot;

  bool isPetLoading = true;
  bool isFunLoading = true;
  final ShopRepository shopRepository = ShopRepository();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    fetchFriend();
    // 상점 신제품 알려주는 모달
    // Future.delayed(Duration.zero, () async {
    //   WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog(context));
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // 효과음 재생 코드
        final assetsAudioPlayer = AssetsAudioPlayer();
        assetsAudioPlayer.open(Audio("assets/main.mp3"));
        assetsAudioPlayer.play();
      }
    });
    // });
  }

  void purchase(idx) async {
    final userInfo = context.read<UserInfo>();
    var result = await shopRepository.purchaseItem(idx, userInfo.userId);
    if (result == true) {
      await fetchFriend();
      Navigator.of(context).pop();
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.8, // 너비 지정
              height: MediaQuery.of(context).size.height * 0.3, // 높이를 지정합니다.

              child: AlertDialog(
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                content: Text(
                  "아이템 구매가 완료 되었어요!",
                  style: TextStyle(fontSize: 17),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      // 다이얼로그 닫기
                      Navigator.of(context).pop();
                      final assetsAudioPlayer = AssetsAudioPlayer();
                      assetsAudioPlayer.open(Audio("assets/main.mp3"));
                      assetsAudioPlayer.play();
                    },
                    child: Text('확인'),
                  ),
                ],
              ),
            );
            // return the Dialog here.
          },
        );
      }
      await userInfo.fetchUser();
    } else {
      if (context.mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.8, // 너비 지정
              height: MediaQuery.of(context).size.height * 0.3, // 높이를 지정합니다.

              child: AlertDialog(
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                title: Center(
                  child: Text(
                    "캐시가 부족합니다.\n할일 완료 후 캐시를 획득 해볼까요?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // 여기에서 스타일을 적용합니다.
                      fontSize: 20, // 글자 크기
                      color: Colors.black, // 글자 색상
                      fontWeight: FontWeight.w500, // 글자 두께
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      // 다이얼로그 닫기
                      Navigator.of(context).pop();
                      final assetsAudioPlayer = AssetsAudioPlayer();
                      assetsAudioPlayer.open(Audio("assets/main.mp3"));
                      assetsAudioPlayer.play();
                    },
                    child: Text(
                      '확인',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
            // return the Dialog here.
          },
        );
      }
    }
  }

  fetchFriend() async {
    final userId = context.read<UserInfo>().userId;
    List<ShopInfo> fetchPets = await shopRepository.getPets(userId);
    setState(() {
      allpets = fetchPets;
      isPetLoading = false;
    });
    List<ShopInfo> fetchFuns = await shopRepository.getFuns(userId);

    setState(() {
      allfuns = fetchFuns;
      isFunLoading = false;
    });
    LOG.log('fetchPets: $fetchPets');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 수
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelStyle: TextStyle(fontSize: 20),
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(text: "애완동물"),
              Tab(text: "가구"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                if (allpets != null && allpets!.isEmpty)
                  Lottie.asset('assets/empty.json',
                      repeat: true,
                      animate: true,
                      height: MediaQuery.of(context).size.height * 0.3),
                if (allpets != null && allpets!.isNotEmpty)
                  ShowItem(
                      allpets: allpets,
                      purchase: purchase,
                      isLoading: isPetLoading),
                if (isPetLoading == true)
                  Lottie.asset('assets/spinner.json',
                      repeat: true,
                      animate: true,
                      height: MediaQuery.of(context).size.height * 0.3),
                if (allfuns != null && allfuns!.isEmpty)
                  Lottie.asset('assets/empty.json',
                      repeat: true,
                      animate: true,
                      height: MediaQuery.of(context).size.height * 0.3),
                if (allfuns != null && allfuns!.isNotEmpty)
                  ShowItem(
                      allpets: allfuns,
                      purchase: purchase,
                      isLoading: isPetLoading),
                if (isFunLoading == true)
                  Lottie.asset('assets/spinner.json',
                      repeat: true,
                      animate: true,
                      height: MediaQuery.of(context).size.height * 0.3),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 상점에 들어오면 이벤트를 알리는 모달
// TODO - css 추가 필요
// void _showDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         width: MediaQuery.of(context).size.width * 0.8, // 너비 지정
//         height: 100, // 높이를 지정합니다.

//         child: AlertDialog(
//           surfaceTintColor: Colors.white,
//           backgroundColor: Colors.white,
//           title: Center(
//             child: Text('새로운 배경 출시!'),
//           ),
//           content: SingleChildScrollView(
//             // SingleChildScrollView를 사용합니다.
//             child: Container(
//               color: Colors.white,
//               width: MediaQuery.of(context).size.width * 0.8, // 너비 지정
//               height: 350, // 여기에서 높이를 지정합니다.
//               child: Column(
//                 children: [
//                   Text(
//                     '이번달 한정판매',
//                     style: TextStyle(
//                       fontSize: 16, // 글자 크기를 16으로 설정합니다.
//                     ),
//                   ),
//                   Image.asset('assets/bg/bg1.png'),
//                   Text(
//                     '초원',
//                     style: TextStyle(
//                       fontSize: 16, // 글자 크기를 16으로 설정합니다.
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 // 다이얼로그 닫기
//                 Navigator.of(context).pop();
//               },
//               child: Text('확인'),
//             ),
//           ],
//         ),
//       );
//       // return the Dialog here.
//     },
//   );
// }
