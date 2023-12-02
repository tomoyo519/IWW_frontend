import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/secrets/secrets.dart';

class ShowItem extends StatelessWidget {
  ShowItem({super.key, this.allpets, this.purchase});
  var allpets;
  final purchase;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Expanded(
          child: allpets.length > 0
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: allpets?.length,
                  itemBuilder: (context, idx) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:
                                  Text('${allpets?[idx].item_name}을 구매하시겠어요?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('예'),
                                  onPressed: () {
                                    purchase(allpets?[idx].item_id);
                                  },
                                ),
                                TextButton(
                                  child: Text('아니요'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 7,
                                  child: Image.asset(
                                    'assets/thumbnail/' +
                                        allpets?[idx].item_path,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey, // 배경색
                                        borderRadius: BorderRadius.only(
                                          bottomLeft:
                                              Radius.circular(10), // 왼쪽 아래 모서리
                                          bottomRight:
                                              Radius.circular(10), // 오른쪽 아래 모서리
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Image(
                                              image:
                                                  AssetImage('assets/coin.png'),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Text(
                                              allpets?[idx].item_cost != null
                                                  ? NumberFormat('#,###')
                                                      .format(allpets?[idx]
                                                          .item_cost)
                                                  : "가격",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          )),
                    );
                  })
              : Text("텅")),
    );
  }
}
