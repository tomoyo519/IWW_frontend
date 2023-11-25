// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class PetAssetManager {
  static final List<PetAssetInfo> _PET_ASSETS = [
    // 전역에서 사용할 펫 에셋 배열
    // SharedPreference에 배열 인덱스를 저장
    PetAssetInfo(
      src: "assets/small_fox.glb",
      alt: "",
      iosSrc: "assets/small_fox.glb",
    ),
    PetAssetInfo(
      src: "assets/mid_fox.glb",
      alt: "",
      iosSrc: "assets/mid_fox.glb",
    ),
    PetAssetInfo(
      src: "assets/kitsune.glb",
      alt: "",
      iosSrc: "assets/kitsune.glb",
    ),
  ];

  static final _count = _PET_ASSETS.length;

  static PetAssetInfo? load(int idx) {
    if (idx < 0 || idx > _count) {
      // 있으면
      return _PET_ASSETS[idx];
    }
    return null;
  }
}

// 에셋 정보
class PetAssetInfo {
  final String src;
  final String alt;
  final String iosSrc;

  const PetAssetInfo({
    required this.src,
    required this.alt,
    required this.iosSrc,
  });
}
