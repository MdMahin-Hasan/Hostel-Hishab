import 'package:hostel_hisab/features/meals/domain/entities/meal_entry.dart';
import 'package:hostel_hisab/features/meals/domain/repositories/meals_repository.dart';

class GetTodayMeals {
  const GetTodayMeals(this._repo);
  final MealsRepository _repo;

  Future<List<MealEntry>> call() => _repo.getTodayMeals();
}
