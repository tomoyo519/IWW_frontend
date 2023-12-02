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

  // 이 두가지는 개입하는 순간 모델링 속도가 느려짐
  // cameraOrbit: "0deg 50deg 0deg",
  // fieldOfView: "120deg",
  // 2 2 0 (좀 작은 버전)
  static final Map<String, ModelViewer> _pets = {
    '구미호03': ModelViewer(
      src: 'assets/pets/kitsune.glb',
      interactionPrompt: InteractionPrompt.none,
      autoPlay: true,
      autoRotate: true,
      shadowIntensity: 1,
      disableZoom: true,
      cameraControls: false,
      animationName: "Walk",
      cameraTarget: "0.7m 0.7m 0m", // x, y, z
      cameraOrbit: "0deg 70deg 5m",
      autoRotateDelay: 0,
      rotationPerSecond: "0.6rad",
    ),
    '구미호02': ModelViewer(
      src: 'assets/pets/mid_fox.glb',
      interactionPrompt: InteractionPrompt.none,
      autoPlay: true,
      autoRotate: true,
      shadowIntensity: 1,
      disableZoom: true,
      cameraControls: false,
      animationName: "Walk",
      cameraTarget: "0.7m 0.7m 0m", // x, y, z
      cameraOrbit: "0deg 70deg 5m",
      // fieldOfView: "90deg",
      autoRotateDelay: 0,
      rotationPerSecond: "0.7rad",
    ),
    '구미호01': ModelViewer(
      src: 'assets/pets/small_fox.glb',
      interactionPrompt: InteractionPrompt.none,
      autoPlay: true,
      autoRotate: true,
      shadowIntensity: 1,
      disableZoom: true,
      cameraControls: false,
      animationName: "Walk",
      cameraTarget: "0.7m 0.7m 0m", // x, y, z
      cameraOrbit: "0deg 70deg 5m",
      // fieldOfView: "90deg",
      autoRotateDelay: 0,
      rotationPerSecond: "0.7rad",
    ),
 


 
  };
}
