enum MealType {
  breakfast('সকাল'),
  lunch('দুপুর'),
  dinner('রাত');

  const MealType(this.label);
  final String label;
}

class MealEntry {
  const MealEntry({
    required this.memberId,
    required this.memberName,
    required this.room,
    this.breakfast = false,
    this.lunch = false,
    this.dinner = false,
  });

  final String memberId, memberName, room;
  final bool breakfast, lunch, dinner;

  bool has(MealType t) => switch (t) {
        MealType.breakfast => breakfast,
        MealType.lunch => lunch,
        MealType.dinner => dinner,
      };

  /// Models are immutable: change = make a new copy.
  MealEntry toggle(MealType t) => MealEntry(
        memberId: memberId,
        memberName: memberName,
        room: room,
        breakfast: t == MealType.breakfast ? !breakfast : breakfast,
        lunch: t == MealType.lunch ? !lunch : lunch,
        dinner: t == MealType.dinner ? !dinner : dinner,
      );
}
