import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:provider/provider.dart';
import 'package:iww_frontend/utils/logger.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryState()),
      ],
      child: InventoryView(),
    );
  }
}

class InventoryState with ChangeNotifier {
  var items = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  double _inventoryHeight = 0.0;

  get intventoryHeight => _inventoryHeight;

  void toggleInventory() {
    _inventoryHeight = _inventoryHeight == 0.0 ? 300.0 : 0.0;
    notifyListeners();
  }
}

class InventoryView extends StatelessWidget {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    var inventoryState = context.watch<InventoryState>();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg/bg7.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: inventoryState.items.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(child: Text(inventoryState.items[idx])),
                  );
                })),
      ),
    );
  }
}
