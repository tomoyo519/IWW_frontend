// ignore_for_file: constant_identifier_names

class RewardService {
  static final RewardService _instance = RewardService._internal();
  RewardService._internal();

  // 캐시 10이 지급되는 로그인 개수
  static const List<int> LOGIN_REWARD = [1, 5, 100];

  static const int PET_EXP_REWARD = 10;
  static const int FIRST_TODO_REWARD = 100;
  static const int NORAML_TODO_REWARD = 10;
  static const int GROUP_TODO_REWARD = 25;
  static const int PET_LEVEL_EXP_LV1 = 1000;
  static const int PET_LEVEL_EXP_LV2 = 2000;

  // 펫 경험치 계산
  static int calculatePetExp(bool isDone) {
    return PET_EXP_REWARD * (isDone ? 1 : -1);
  }

  // 개인투두 보상 계산
  static int calculateNormalCash(bool isDone, int todayDone) {
    if ((isDone && todayDone == 0) || (!isDone && todayDone == 1)) {
      // 투두를 완료 체크한 경우 (첫 번째 투두 체크 또는 마지막 투두 체크해제)
      return isDone ? 100 : -100;
    } else if (isDone && todayDone >= 10) {
      // 개인 투두 달성 보상은 10개까지 제한
      return 0;
    }
    // 기본 캐시 계산
    return NORAML_TODO_REWARD * (isDone ? 1 : -1);
  }

  // 그룹투두 보상 계산
  static int calculateGroupCash(bool isDone, int todayDone) {
    if ((isDone && todayDone == 0) || (!isDone && todayDone == 1)) {
      // 투두를 완료 체크한 경우 (첫 번째 투두 체크 또는 마지막 투두 체크해제)
      return FIRST_TODO_REWARD * (isDone ? 1 : -1);
    }
    // 기본 캐시 계산
    return GROUP_TODO_REWARD * (isDone ? 1 : -1);
  }
}
