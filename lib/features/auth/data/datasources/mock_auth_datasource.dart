import 'package:hostel_hisab/core/errors/app_exception.dart';
import 'package:hostel_hisab/features/auth/data/datasources/auth_remote_datasource.dart';

class MockAuthDataSource implements AuthRemoteDataSource {
  @override
  Future<Map<String, dynamic>> login({required String id, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (id.isEmpty || password.length < 4) {
      throw const AppException('মোবাইল নম্বর বা পাসওয়ার্ড ভুল');
    }
    return {'name': 'রাহিম উদ্দিন'};
  }

  @override
  Future<void> logout() async {}
}
