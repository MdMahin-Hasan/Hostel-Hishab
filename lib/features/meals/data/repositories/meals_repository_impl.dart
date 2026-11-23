import 'package:hostel_hisab/features/meals/data/datasources/meals_remote_datasource.dart';
import 'package:hostel_hisab/features/meals/data/models/meal_entry_model.dart';
import 'package:hostel_hisab/features/meals/domain/entities/meal_entry.dart';
import 'package:hostel_hisab/features/meals/domain/repositories/meals_repository.dart';

class MealsRepositoryImpl implements MealsRepository {
  const MealsRepositoryImpl(this._remote);
  final MealsRemoteDataSource _remote;

  @override
  Future<List<MealEntry>> getTodayMeals() async {
    final list = await _remote.fetchToday();
    return list.map(MealEntryModel.fromJson).toList();
  }

  @override
  Future<void> saveTodayMeals(List<MealEntry> entries) {
    return _remote.saveToday(
      entries.map((e) => MealEntryModel.fromEntity(e).toJson()).toList(),
    );
  }
}
