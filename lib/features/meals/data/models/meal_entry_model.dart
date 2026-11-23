import 'package:hostel_hisab/features/meals/domain/entities/meal_entry.dart';

class MealEntryModel extends MealEntry {
  const MealEntryModel({
    required super.memberId,
    required super.memberName,
    required super.room,
    super.breakfast = false,
    super.lunch = false,
    super.dinner = false,
  });

  factory MealEntryModel.fromJson(Map<String, dynamic> json) => MealEntryModel(
        memberId: json['memberId'] as String,
        memberName: json['memberName'] as String,
        room: json['room'] as String,
        breakfast: json['breakfast'] as bool? ?? false,
        lunch: json['lunch'] as bool? ?? false,
        dinner: json['dinner'] as bool? ?? false,
      );

  factory MealEntryModel.fromEntity(MealEntry e) => MealEntryModel(
        memberId: e.memberId,
        memberName: e.memberName,
        room: e.room,
        breakfast: e.breakfast,
        lunch: e.lunch,
        dinner: e.dinner,
      );

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'memberName': memberName,
        'room': room,
        'breakfast': breakfast,
        'lunch': lunch,
        'dinner': dinner,
      };
}
