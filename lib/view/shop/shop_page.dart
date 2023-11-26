import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {}, icon: Icon(Icons.catching_pokemon_outlined))
      ]),
      body: ChangeNotifierProvider(
        create: (context) => ShopPageState(),
        child: ShopItems(),
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}

class ShopPageState extends ChangeNotifier {
  int mymoney = 1000;
  var allItems = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  var ownItems = ['a', 'b', 'd'];
}

class ShopItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var shopState = context.watch<ShopPageState>();
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
                Icon(Icons.pets_outlined),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount: shopState.allItems.length,
                          itemBuilder: (context, idx) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Card(child: Text(shopState.allItems[idx])),
                            );
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount: shopState.ownItems.length,
                          itemBuilder: (context, idx) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Card(child: Text(shopState.ownItems[idx])),
                            );
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
