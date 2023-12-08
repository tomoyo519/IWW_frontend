import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iww_frontend/secrets/secrets.dart';
import 'package:lottie/lottie.dart';

class ShowItem extends StatelessWidget {
  ShowItem({super.key, this.allpets, this.purchase});
  var allpets;
  final purchase;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: allpets.length > 0
            ? ListView.builder(
                itemCount: allpets?.length,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            title: Center(
                              child: Text(
                                '${allpets?[idx].item_name}을 \n구매하시겠어요?',
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
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      child: Text('예',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () {
                                        purchase(allpets?[idx].item_id);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10), // 버
                                  Expanded(
                                    child: TextButton(
                                      child: Text('아니요',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // 원하는 radius 값으로 변경 가능합니다.
                                  child: Image.asset(
                                    'assets/thumbnail/' +
                                        allpets?[idx].item_path,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        allpets?[idx].item_name ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        allpets?[idx].item_desc ?? "",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/cash.png',
                                            width: 25,
                                            height: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
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
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  );
                })
            : Lottie.asset('assets/empty.json',
                repeat: true,
                animate: true,
                height: MediaQuery.of(context).size.height * 0.3));
  }
}
