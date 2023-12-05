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
    Future.delayed(Duration.zero, () async {
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
    List<ShopInfo> fetchEmoj = await shopRepository.getEmoj(userId);
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
                      if (allemot!.isNotEmpty) ...[
                        ShowItem(allpets: allemot, purchase: purchase),
                      ],
                      if (allemot!.isEmpty) ...[
                        Lottie.asset('assets/empty.json',
                            repeat: true,
                            animate: true,
                            height: MediaQuery.of(context).size.height * 0.3),
                      ]
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
