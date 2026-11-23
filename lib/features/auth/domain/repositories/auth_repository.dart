/// DOMAIN contract: what the app needs. No JSON, no HTTP here.
abstract class AuthRepository {
  /// Returns the user's display name.
  Future<String> login({required String id, required String password});
  Future<void> logout();
}
