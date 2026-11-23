abstract class FinanceRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchTransactions();
  Future<Map<String, dynamic>> addDeposit(Map<String, dynamic> payload);
  Future<Map<String, dynamic>> approve(String id);
}
