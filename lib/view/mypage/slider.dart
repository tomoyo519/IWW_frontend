//
//  CarouselSliderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/8/21 5:00 PM.
//  Copyright © 6/8/21 shang. All rights reserved.
//

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iww_frontend/view/shop/shop_page.dart';

class CarouselSliderDemo extends StatelessWidget {
  const CarouselSliderDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/banner1.png',
      'assets/banner2.png',
      'assets/banner3.png'
    ];

    final List<Widget> imageSliders = imgList
        .map(
          (item) => InkWell(
            onTap: () {
              // TODO - no widget found....
              //   LOG.log('클릭되긴 하고요?');
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ShopPage()),
              //   );
            },
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: [
                      Image.asset(item,
                          fit: BoxFit.cover, width: double.infinity),
                    ],
                  )),
            ),
          ),
        )
        .toList();

    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
            child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                autoPlayInterval: Duration(seconds: 5),
                viewportFraction: 1.0,
                autoPlay: true,
              ),
              items: imageSliders,
            ),
          ],
        ));
      }),
    );
  }
}
