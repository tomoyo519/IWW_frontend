class RewardService {
  static final RewardService _instance = RewardService._internal();
  RewardService._internal();

  // 상수 정의
  static const int _maxDailyTasks = 50;
  static const int _minGroupTasks = 10;
  static const int _petExpForGroupDone = 10;
  static const int _petExpForGroupNotDone = -10;
  static const int _petExpForSingleDone = 5;
  static const int _petExpForSingleNotDone = -5;
  static const int _cashForFirstTask = 100;
  static const int _cashPenaltyForFirstTaskNotDone = -100;
  static const int _cashNoChange = 0;
  static const int _cashPenaltyForManyTasks = -10;
  static const int _cashForGroupDone = 25;
  static const int _cashForGroupNotDone = -25;
  static const int _cashForSingleDone = 10;
  static const int _cashForSingleNotDone = -10;

  // 펫 경험치 계산 메소드
  static int calculatePetExp(bool isDone, bool isGroup, int todayDone) {
    if (!isGroup && todayDone >= _maxDailyTasks) {
      return isDone ? _cashNoChange : _petExpForSingleNotDone;
    }
    return isGroup
        ? (isDone ? _petExpForGroupDone : _petExpForGroupNotDone)
        : (isDone ? _petExpForSingleDone : _petExpForSingleNotDone);
  }

  // 현금 계산 메소드
  static int calculateCash(bool isDone, bool isGroup, int todayDone) {
    if ((isDone && todayDone == 0) || (!isDone && todayDone == 1)) {
      return isDone ? _cashForFirstTask : _cashPenaltyForFirstTaskNotDone;
    } else if (!isGroup && todayDone >= _minGroupTasks) {
      return isDone ? _cashNoChange : _cashPenaltyForManyTasks;
    }

    return isGroup
        ? (isDone ? _cashForGroupDone : _cashForGroupNotDone)
        : (isDone ? _cashForSingleDone : _cashForSingleNotDone);
  }
}
