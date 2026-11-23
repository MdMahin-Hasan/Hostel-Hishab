import 'package:hostel_hisab/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repo);
  final AuthRepository _repo;

  Future<String> call({required String id, required String password}) =>
      _repo.login(id: id.trim(), password: password);
}
