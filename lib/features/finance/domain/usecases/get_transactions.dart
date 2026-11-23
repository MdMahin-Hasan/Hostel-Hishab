import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/domain/repositories/finance_repository.dart';

class GetTransactions {
  const GetTransactions(this._repo);
  final FinanceRepository _repo;

  Future<List<TxItem>> call() => _repo.getTransactions();
}
