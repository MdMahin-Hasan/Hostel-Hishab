import 'package:hostel_hisab/features/meals/domain/entities/meal_entry.dart';

abstract class MealsRepository {
  Future<List<MealEntry>> getTodayMeals();
  Future<void> saveTodayMeals(List<MealEntry> entries);
}
