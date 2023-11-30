import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/_navigation/main_page.dart';
import 'package:iww_frontend/view/pet/deceasedPet.dart';
import 'package:iww_frontend/view/pet/evolutionPet.dart';
import 'package:iww_frontend/view/pet/revivalPet.dart';
import 'package:transparent_image/transparent_image.dart';

class ModalSample extends StatelessWidget {
  const ModalSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (BuildContext buildContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Expanded(
                    child: EvolPet(),
                  );
                },
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 300),
              );
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });
            },
            child: Text("진화2")),
        ElevatedButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (BuildContext buildContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Container(
                    color: Colors.black,
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Center(child: CircularProgressIndicator()),
                          Center(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  'https://i.pinimg.com/originals/3c/11/bf/3c11bf28a39606f5bfc7bb66ff3f217b.gif',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 300),
              );
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
            },
            child: Text("진화")),
        ElevatedButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (BuildContext buildContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Expanded(
                    child: DeceasedPet(),
                  );
                },
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 300),
              );
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });
            },
            child: Text("죽음")),
        ElevatedButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (BuildContext buildContext,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Expanded(
                    child: RevivalPet(),
                  );
                },
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 300),
              );
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });
            },
            child: Text("부활")),
      ]),
      bottomNavigationBar: MainPage(),
    );
  }
}
