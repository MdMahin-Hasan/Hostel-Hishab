abstract class MealsRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchToday();
  Future<void> saveToday(List<Map<String, dynamic>> entries);
}
