import 'package:hostel_hisab/features/meals/data/datasources/meals_remote_datasource.dart';

class MockMealsDataSource implements MealsRemoteDataSource {
  List<Map<String, dynamic>> _db = [
    {'memberId': '1', 'memberName': 'রহিমা বেগম', 'room': '১২এ', 'breakfast': true, 'lunch': true, 'dinner': true},
    {'memberId': '2', 'memberName': 'আরিফুল ইসলাম', 'room': '২১বি', 'breakfast': true, 'lunch': true, 'dinner': false},
    {'memberId': '3', 'memberName': 'সোফিয়া আক্তার', 'room': '০৩সি', 'breakfast': false, 'lunch': true, 'dinner': true},
    {'memberId': '4', 'memberName': 'কামাল হোসেন', 'room': '১০ডি', 'breakfast': true, 'lunch': true, 'dinner': true},
  ];

  @override
  Future<List<Map<String, dynamic>>> fetchToday() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.of(_db);
  }

  @override
  Future<void> saveToday(List<Map<String, dynamic>> entries) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _db = List.of(entries);
  }
}
