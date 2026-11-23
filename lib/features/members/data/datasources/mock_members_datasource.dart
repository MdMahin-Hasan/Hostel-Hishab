import 'package:hostel_hisab/features/members/data/datasources/members_remote_datasource.dart';

class MockMembersDataSource implements MembersRemoteDataSource {
  // Looks exactly like what your Node/MongoDB API will return later.
  final List<Map<String, dynamic>> _db = [
    {'_id': '1', 'name': 'রহিমা বেগম', 'room': '১২এ', 'balance': 0},
    {'_id': '2', 'name': 'আরিফুল ইসলাম', 'room': '২১বি', 'balance': -450},
    {'_id': '3', 'name': 'সোফিয়া আক্তার', 'room': '০৩সি', 'balance': 120},
    {'_id': '4', 'name': 'কামাল হোসেন', 'room': '১০ডি', 'balance': 0},
    {'_id': '5', 'name': 'নাজিয়া সুলতানা', 'room': '০৭এ', 'balance': -850},
  ];

  @override
  Future<List<Map<String, dynamic>>> fetchMembers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.of(_db);
  }

  @override
  Future<Map<String, dynamic>> addMember(Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final doc = {
      '_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'balance': 0,
      ...payload,
    };
    _db.add(doc);
    return doc;
  }
}
