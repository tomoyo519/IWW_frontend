import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_navigator.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/modals/custom_fullscreen_modal.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

// static method
void showPetEvolveModal(BuildContext context) {
  showCustomFullScreenModal(
    context: context,
    builder: (context) => PetEvolveModal(),
  );
}

class PetEvolveModal extends StatelessWidget {
  const PetEvolveModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
            // color: Colors.white,
            ),
        child: Stack(
          children: [
            Material(
              child: SizedBox(
                height: screen.height,
                width: screen.width,
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: ModelViewer(
                        loading: Loading.eager,
                        shadowIntensity: 1,
                        src: 'assets/pets/mid_fox.glb',
                        alt: 'cuttest pet ever',
                        autoRotate: false,
                        animationName: "Idle_A",
                        autoPlay: true,
                        disableZoom: true,
                        cameraOrbit: '25deg 75deg 105%',
                        interactionPrompt: InteractionPrompt.none,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            "펫이 진화했어요!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "홈으로 가기",
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            // FadeTransition(
            //   opacity: _fadeAnimation,
            //   child: Container(
            //     width: double.infinity,
            //     height: double.infinity,
            //     decoration: BoxDecoration(
            //       color: Colors.black,
            //     ),
            //     child: Lottie.asset(
            //       "assets/todo/evolve.json",
            //       width: double.infinity,
            //       height: double.infinity,
            //       controller: _lottieController,
            //       onLoaded: (composition) {
            //         _lottieController.duration = composition.duration;
            //         _lottieController.forward().then((value) {
            //           _fadeController.forward();
            //         });
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
