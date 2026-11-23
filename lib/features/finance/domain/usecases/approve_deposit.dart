import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/domain/repositories/finance_repository.dart';

/// Manager action: a pending deposit becomes approved and counts in balance.
class ApproveDeposit {
  const ApproveDeposit(this._repo);
  final FinanceRepository _repo;

  Future<TxItem> call(String id) => _repo.approveDeposit(id);
}
