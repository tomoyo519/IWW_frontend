import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:iww_frontend/utils/logger.dart';

class PetModels {
  static ModelViewer getPetWidget(String petName) {
    if (_pets.keys.contains(petName)) {
      return _pets[petName]!;
    }

    LOG.log('NO SUCH PET: $petName');
    return _pets['kitsune']!;
  }

  static final Map<String, ModelViewer> _pets = {
    'kitsune': ModelViewer(
      interactionPrompt: InteractionPrompt.none,
      autoPlay: true,
      autoRotate: true,
      shadowIntensity: 1,
      disableZoom: true,
      cameraControls: false,
      src: 'assets/pets/kitsune.glb',
      animationName: "Fly",
      cameraTarget: "2m 2m 0m", // 회전방향 (각도), 높이(클수록 작아짐), 회전 반경
      // cameraOrbit: ,
      autoRotateDelay: 0,
      // fieldOfView: "20deg",
      rotationPerSecond: "0.6rad",
    ),
    'small_fox': ModelViewer(
      interactionPrompt: InteractionPrompt.none,
      autoPlay: true,
      autoRotate: true,
      shadowIntensity: 1,
      disableZoom: true,
      cameraControls: false,
      src: 'assets/pets/small_fox.glb',
      animationName: "Jump",
      cameraOrbit: "330deg,0deg, 0m",
      cameraTarget: "0.3m 1.1m 0.7m",
    ),
    'mid_fox': ModelViewer(
      interactionPrompt: InteractionPrompt.none,
      autoPlay: true,
      autoRotate: true,
      shadowIntensity: 1,
      disableZoom: true,
      cameraControls: false,
      src: 'assets/pets/mid_fox.glb',
      animationName: "Idle_A",
      cameraOrbit: "30deg, 150deg, 0m",
      cameraTarget: "0m 0.8m 0.4m",
    ),
  };
}
