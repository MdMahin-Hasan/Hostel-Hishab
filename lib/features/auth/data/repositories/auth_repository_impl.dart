import 'package:hostel_hisab/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hostel_hisab/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);
  final AuthRemoteDataSource _remote;

  @override
  Future<String> login({required String id, required String password}) async {
    final json = await _remote.login(id: id, password: password);
    return json['name'] as String;
  }

  @override
  Future<void> logout() => _remote.logout();
}
