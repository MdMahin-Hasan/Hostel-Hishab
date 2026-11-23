/// DATA layer: talks to the outside world and speaks JSON (Map).
abstract class AuthRemoteDataSource {
  /// Returns JSON like {"name": "..."}.
  Future<Map<String, dynamic>> login({required String id, required String password});
  Future<void> logout();
}
