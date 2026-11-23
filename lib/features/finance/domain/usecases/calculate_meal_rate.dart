/// meal rate = total bazar cost / total meals
class CalculateMealRate {
  const CalculateMealRate();

  double call({required int bazarTotal, required int totalMeals}) =>
      totalMeals == 0 ? 0 : bazarTotal / totalMeals;
}
