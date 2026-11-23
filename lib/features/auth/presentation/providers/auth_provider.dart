import 'package:hostel_hisab/core/base/base_provider.dart';
import 'package:hostel_hisab/features/auth/domain/usecases/login_usecase.dart';
import 'package:hostel_hisab/features/auth/domain/usecases/logout_usecase.dart';

class AuthProvider extends BaseProvider {
  AuthProvider({required LoginUseCase login, required LogoutUseCase logout})
      : _login = login,
        _logout = logout;

  final LoginUseCase _login;
  final LogoutUseCase _logout;

  String userName = '';
  bool get isLoggedIn => userName.isNotEmpty;

  Future<bool> login(String id, String password) async {
    await run(() async {
      userName = await _login(id: id, password: password);
    });
    return isLoggedIn;
  }

  Future<void> logout() async {
    await _logout();
    userName = '';
    notifyListeners();
  }
}
