import 'package:flutter/material.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/model/shop/shop.model.dart';
import 'package:iww_frontend/repository/shop.repository.dart';
import 'dart:convert';
import 'package:iww_frontend/utils/logger.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Row(
          children: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.catching_pokemon_outlined)),
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {},
              color: (Colors.black),
            )
          ],
        )
      ]),
      body: ShopItems(),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}

// cla
class ShopItems extends StatefulWidget {
  const ShopItems({super.key});
  @override
  State<ShopItems> createState() => _ShopItems();

  // @override
  // State<ShopItems> createState() => _ShopItemsState();
}

class _ShopItems extends State<ShopItems> {
  List<dynamic>? allpets;
  List<dynamic>? allfuns;
  List<dynamic>? allemot;
  final ShopRepository shopRepository = ShopRepository();

  @override
  void initState() {
    super.initState();
    fetchFriend();
  }

  Future<void> fetchFriend() async {
    List<ShopInfo> fetchPets = await shopRepository.getPets();
    List<ShopInfo> fetchFuns = await shopRepository.getFuns();
    List<ShopInfo> fetchEmoj = await shopRepository.getEmoj();
    setState(() {
      allpets = fetchPets;
      allfuns = fetchFuns;
      allemot = fetchEmoj;
    });
    LOG.log('allfuns:$allfuns');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 탭의 수
      child: Column(
        children: [
          TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.pets_outlined)),
              Tab(icon: Icon(Icons.emoji_emotions_outlined)),
              Tab(icon: Icon(Icons.category_outlined)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: allpets?.length,
                          itemBuilder: (context, idx) {
                            return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Image(
                                          image: AssetImage(allpets?[idx]
                                                  .item_path ??
                                              'default_image_path'), // 'default_image_path'는 기본 이미지 경로로 변경하세요.
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(allpets?[idx].item_name),
                                        subtitle: Row(
                                          children: [
                                            Icon(
                                                Icons.monetization_on_outlined),
                                            Text(allpets?[idx]
                                                    .item_cost
                                                    .toString() ??
                                                ""),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: allfuns?.length,
                          itemBuilder: (context, idx) {
                            return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Image(
                                          image: AssetImage(allfuns?[idx]
                                                  .item_path ??
                                              'default_image_path'), // 'default_image_path'는 기본 이미지 경로로 변경하세요.
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(allfuns?[idx].item_name),
                                        subtitle: Row(
                                          children: [
                                            Icon(
                                                Icons.monetization_on_outlined),
                                            Text(allfuns?[idx]
                                                    .item_cost
                                                    .toString() ??
                                                ""),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: allemot?.length,
                          itemBuilder: (context, idx) {
                            return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Image(
                                          image: AssetImage(allemot?[idx]
                                                  .item_path ??
                                              'default_image_path'), // 'default_image_path'는 기본 이미지 경로로 변경하세요.
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(allemot?[idx].item_name),
                                        subtitle: Row(
                                          children: [
                                            Icon(
                                                Icons.monetization_on_outlined),
                                            Text(allemot?[idx]
                                                    .item_cost
                                                    .toString() ??
                                                ""),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
