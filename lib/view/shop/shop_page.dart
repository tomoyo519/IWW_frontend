import 'package:flutter/material.dart';
import 'package:iww_frontend/model/shop/shop.model.dart';
import 'package:iww_frontend/repository/shop.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/view/shop/layout/show_item.dart';
import 'package:iww_frontend/viewmodel/user-info.viewmodel.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShopItems();
  }
}

// cla
class ShopItems extends StatefulWidget {
  const ShopItems({super.key});
  @override
  State<ShopItems> createState() => _ShopItems();
}

class _ShopItems extends State<ShopItems> {
  List<ShopInfo>? allpets;
  List<dynamic>? allfuns;
  List<dynamic>? allemot;
  bool isLoading = true;
  final ShopRepository shopRepository = ShopRepository();

  @override
  void initState() {
    super.initState();
    ;
    Future.delayed(Duration.zero, () async {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog(context));
      await fetchFriend();

      LOG.log('thisisallpets: $allpets');
    });
    LOG.log('thisisallpets: $allpets');
  }

  void purchase(idx) async {
    final userInfo = context.read<UserInfo>();
    var result = await shopRepository.purchaseItem(idx, userInfo.userId);
    if (result == true) {
      await fetchFriend();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("아이템 구매가 완료 되었어요!")));
      Navigator.pop(context);
      await userInfo.fetchUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("보유한 캐시가 부족해요. 할일을 더 수행해볼까요?")));
      Navigator.pop(context);
    }
  }

  fetchFriend() async {
    final userId = context.read<UserInfo>().userId;
    List<ShopInfo> fetchPets = await shopRepository.getPets(userId);
    List<ShopInfo> fetchFuns = await shopRepository.getFuns(userId);
    // List<ShopInfo> fetchEmoj = await shopRepository.getEmoj(userId);
    LOG.log('fetchPets: $fetchPets');
    if (mounted) {
      // 안하면 중간에 앱 멈추는 현상 발견
      setState(() {
        allpets = fetchPets;
        allfuns = fetchFuns;
        // allemot = fetchEmoj;
      });
      LOG.log('thisis$allfuns');
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 수
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(text: ("애완동물")),
              Tab(text: "가구"),
              // Tab(text: "이모티콘"),
            ],
          ),
          !isLoading
              ? Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      if (allpets!.isEmpty) ...[
                        Lottie.asset('assets/empty.json',
                            repeat: true,
                            animate: true,
                            height: MediaQuery.of(context).size.height * 0.3),
                      ],
                      if (allpets!.isNotEmpty) ...[
                        ShowItem(allpets: allpets, purchase: purchase),
                      ],
                      if (allfuns!.isEmpty) ...[
                        Lottie.asset('assets/empty.json',
                            repeat: true,
                            animate: true,
                            height: MediaQuery.of(context).size.height * 0.3),
                      ],
                      if (allfuns!.isNotEmpty) ...[
                        ShowItem(allpets: allfuns, purchase: purchase),
                      ],
                    ],
                  ),
                )
              : Lottie.asset('assets/spinner.json',
                  repeat: true,
                  animate: true,
                  height: MediaQuery.of(context).size.height * 0.3),
        ],
      ),
    );
  }
}

// 상점에 들어오면 이벤트를 알리는 모달
// TODO - css 추가 필요
void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.6, // 너비 지정
        height: 100, // 높이를 지정합니다.

        child: AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Center(
            child: Text('새로운 배경 출시!'),
          ),
          content: SingleChildScrollView(
            // SingleChildScrollView를 사용합니다.
            child: Container(
              color: Colors.white,
              height: 350, // 여기에서 높이를 지정합니다.
              child: Column(
                children: [
                  Text(
                    '이번달 한정판매',
                    style: TextStyle(
                      fontSize: 16, // 글자 크기를 16으로 설정합니다.
                    ),
                  ),
                  Image.asset('assets/bg/bg1.png'),
                  Text(
                    '초원',
                    style: TextStyle(
                      fontSize: 16, // 글자 크기를 16으로 설정합니다.
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 다이얼로그 닫기
                Navigator.of(context).pop();
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
