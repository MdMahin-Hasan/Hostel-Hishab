import 'package:hostel_hisab/core/base/base_provider.dart';
import 'package:hostel_hisab/features/meals/domain/entities/meal_entry.dart';
import 'package:hostel_hisab/features/meals/domain/usecases/get_today_meals.dart';
import 'package:hostel_hisab/features/meals/domain/usecases/save_today_meals.dart';

class MealsProvider extends BaseProvider {
  MealsProvider({required GetTodayMeals getTodayMeals, required SaveTodayMeals saveTodayMeals})
      : _get = getTodayMeals,
        _save = saveTodayMeals;

  final GetTodayMeals _get;
  final SaveTodayMeals _save;

  List<MealEntry> _entries = [];
  bool _dirty = false;

  List<MealEntry> get entries => _entries;
  bool get isDirty => _dirty;

  /// Mock value. Later this comes from the backend (sum of month's meals).
  int get monthTotalMeals => 1020;

  int total(MealType t) => _entries.where((e) => e.has(t)).length;

  Future<void> load() => run(() async {
        _entries = await _get();
        _dirty = false;
      });

  void toggle(String memberId, MealType t) {
    _entries = [for (final e in _entries) e.memberId == memberId ? e.toggle(t) : e];
    _dirty = true;
    notifyListeners();
  }

  Future<void> save() => run(() async {
        await _save(_entries);
        _dirty = false;
      });
}
