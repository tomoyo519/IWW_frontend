class WeekDay {
  final int idx;
  final String name;
  final bool selected;

  WeekDay({
    required this.idx,
    required this.name,
    required this.selected,
  });
}

class WeekRepeat {
  final int count;
  final List<WeekDay> weekday;
  final String name;
  WeekRepeat({
    required this.count,
    required this.weekday,
    required this.name,
  });
}
