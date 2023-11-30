import 'package:flutter/material.dart';
import 'package:iww_frontend/model/shop/shop.model.dart';
import 'package:iww_frontend/repository/shop.repository.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:iww_frontend/view/shop/layout/show_item.dart';

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
    Future.delayed(Duration.zero, () async {
      await fetchFriend();
      LOG.log('thisisallpets: $allpets');
    });
    LOG.log('thisisallpets: $allpets');
  }

  void purchase(idx) async {
    var result = await shopRepository.purchaseItem(idx);
    if (result == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("아이템 구매가 완료 되었어요!")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("아이템 구매를 실패했어요! 다시 시도해주세요.")));
      Navigator.pop(context);
    }
  }

  fetchFriend() async {
    List<ShopInfo> fetchPets = await shopRepository.getPets();
    List<ShopInfo> fetchFuns = await shopRepository.getFuns();
    List<ShopInfo> fetchEmoj = await shopRepository.getEmoj();
    LOG.log('fetchPets: $fetchPets');
    if (mounted) {
      // 안하면 중간에 앱 멈추는 현상 발견
      setState(() {
        allpets = fetchPets;
        allfuns = fetchFuns;
        allemot = fetchEmoj;
      });
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    // return Text("HELLO");
    return DefaultTabController(
      length: 3, // 탭의 수
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(text: ("애완동물")),
              Tab(text: "가구"),
              Tab(text: "이모티콘"),
            ],
          ),
          // TODO - 재사용성 확인하기
          !isLoading
              ? Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      ShowItem(allpets: allpets, purchase: purchase),
                      ShowItem(allpets: allfuns, purchase: purchase),
                      ShowItem(
                        allpets: allemot,
                        purchase: purchase,
                      )
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
