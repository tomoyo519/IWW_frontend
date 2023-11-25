import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("어서오세요! 샵입니다."), backgroundColor: Colors.transparent),
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
  var ownItmes = ['a', 'b', 'd'];
}

class ShopItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var shopState = context.watch<ShopPageState>();
    return Column(
      children: [
        Container(
          height: 20,
          child: Text('내 돈 : ${shopState.mymoney}'),
        ),
        GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.all(10),
            children: <Widget>[
              Container(
                color: Colors.teal[100],
                child: Text('ShopItems1'),
              ),
              Container(
                color: Colors.green[100],
                child: Text('ShopItems2'),
              ),
              Container(
                color: Colors.teal[300],
                child: Text('ShopItems3'),
              ),
              Container(
                color: Colors.teal[200],
                child: Text('ShopItems4'),
              ),
              Container(
                color: Colors.cyan[100],
                child: Text('ShopItems5'),
              ),
              Container(
                color: Colors.green[300],
                child: Text('ShopItems6'),
              ),
              Container(
                color: Colors.cyan[100],
                child: Text('ShopItems7'),
              ),
              Container(
                color: Colors.green[500],
                child: Text('ShopItems8'),
              ),
              Container(
                color: Colors.cyan[100],
                child: Text('ShopItems9'),
              ),
              Container(
                color: Colors.cyan[200],
                child: Text('ShopItems10'),
              ),
              Container(
                color: Colors.cyan[300],
                child: Text('ShopItems11'),
              ),
            ]),
      ],
    );
  }
}
