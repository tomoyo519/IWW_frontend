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
      animationName: "Walk",
      cameraTarget: "0.9m 0.9m -0.3m", // x, y, z
      // 2 2 0 (좀 작은 버전)
      autoRotateDelay: 0,
      rotationPerSecond: "0.6rad",
      // 이 두가지는 개입하는 순간 모델링 속도가 느려짐
      // cameraOrbit: "0deg 50deg 0deg",
      // fieldOfView: "120deg",
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
