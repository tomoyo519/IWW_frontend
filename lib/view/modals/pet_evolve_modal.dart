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

class PetEvolveModal extends StatefulWidget {
  const PetEvolveModal({
    super.key,
  });

  @override
  State<PetEvolveModal> createState() => _PetEvolveModalState();
}

class _PetEvolveModalState extends State<PetEvolveModal>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final petId = 0;
  final nextPetId = 0;
  late ModelViewer model;
  bool evolved = false;

  @override
  void initState() {
    super.initState();

    // Get model
    model = const ModelViewer(
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
    );

    _lottieController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_fadeController);

    // Lottie 애니메이션 로드 및 시작
    _lottieController.forward();

    // 특정 지점에서 페이드 아웃 시작
    Timer(Duration(seconds: 1), () {
      _fadeController.forward(); // 1초 후 페이드 아웃 시작
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
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
                      child: model,
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
                          ElevatedButton(
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
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Lottie.asset(
                  "assets/todo/evolve.json",
                  width: double.infinity,
                  height: double.infinity,
                  controller: _lottieController,
                  onLoaded: (composition) {
                    _lottieController.duration = composition.duration;
                    _lottieController.forward().then((value) {
                      _fadeController.forward();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
