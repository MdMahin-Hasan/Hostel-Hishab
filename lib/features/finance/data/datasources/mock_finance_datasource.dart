import 'package:hostel_hisab/features/finance/data/datasources/finance_remote_datasource.dart';

class MockFinanceDataSource implements FinanceRemoteDataSource {
  final List<Map<String, dynamic>> _db = [
    {'_id': '1', 'title': 'বাজার', 'who': 'রফিক', 'date': '2026-10-28', 'amount': 3600, 'type': 'bazar', 'status': 'approved'},
    {'_id': '2', 'title': 'সেটেলমেন্ট', 'who': 'সুমাইয়া', 'date': '2026-10-20', 'amount': 2800, 'type': 'settlement', 'status': 'approved'},
    {'_id': '3', 'title': 'বাজার', 'who': 'রফিক', 'date': '2026-10-12', 'amount': 4200, 'type': 'bazar', 'status': 'approved'},
    {'_id': '4', 'title': 'ক্যাশ তোলা', 'who': 'নাজিয়া', 'date': '2026-10-05', 'amount': 1500, 'type': 'withdraw', 'status': 'approved'},
    {'_id': '5', 'title': 'ফেরত', 'who': 'আরিফ', 'date': '2026-10-02', 'amount': 320, 'type': 'refund', 'status': 'approved'},
    {'_id': '6', 'title': 'বাজার', 'who': 'কামাল', 'date': '2026-10-02', 'amount': 1700, 'type': 'bazar', 'status': 'approved'},
    {'_id': '7', 'title': 'মাসিক জমা', 'who': 'সবাই', 'date': '2026-10-01', 'amount': 15000, 'type': 'deposit', 'status': 'approved'},
  ];

  static const _labels = {'bkash': 'বিকাশ', 'bank': 'ব্যাংক', 'cash': 'নগদ'};

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.of(_db);
  }

  @override
  Future<Map<String, dynamic>> addDeposit(Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final doc = {
      '_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': 'জমা - ${_labels[payload['method']]}',
      'who': 'রাহিম',
      'date': DateTime.now().toIso8601String(),
      'type': 'deposit',
      'status': 'pending', // manager must approve before it counts
      ...payload,
    };
    _db.insert(0, doc);
    return doc;
  }

  @override
  Future<Map<String, dynamic>> approve(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final i = _db.indexWhere((d) => d['_id'] == id);
    _db[i] = {..._db[i], 'status': 'approved'};
    return _db[i];
  }
}
