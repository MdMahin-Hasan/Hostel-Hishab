import 'package:hostel_hisab/features/meals/domain/entities/meal_entry.dart';
import 'package:hostel_hisab/features/meals/domain/repositories/meals_repository.dart';

class SaveTodayMeals {
  const SaveTodayMeals(this._repo);
  final MealsRepository _repo;

  Future<void> call(List<MealEntry> entries) => _repo.saveTodayMeals(entries);
}
