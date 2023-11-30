import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class EvolPetModal extends StatefulWidget {
  // final
  const EvolPetModal({
    super.key,
  });

  @override
  State<EvolPetModal> createState() => _EvolPetModalState();
}

class _EvolPetModalState extends State<EvolPetModal>
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
      src: 'assets/kitsune_ani.glb',
      alt: 'cuttest pet ever',
      autoRotate: false,
      animationName: "Idle_A",
      autoPlay: true,
      disableZoom: true,
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

    // set state
    // _lottieController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     // show model
    //     setState(() {
    //       evolved = true;
    //     });
    //   }
    // });

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
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
          ),
          child: Stack(
            children: [
              model,
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
                    // onLoaded: (composition) {
                    //   _lottieController.duration = composition.duration;
                    //   _lottieController.forward().then((value) {
                    //     _fadeController.forward();
                    //   });
                    // },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
