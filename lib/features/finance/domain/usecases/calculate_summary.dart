import 'package:hostel_hisab/features/finance/domain/entities/finance_summary.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';

/// Pure business rule - no Flutter, no network. Easy to unit test.
/// Pending transactions are NOT counted.
class CalculateSummary {
  const CalculateSummary();

  FinanceSummary call(List<TxItem> txs) {
    final approved = txs.where((t) => t.status == TxStatus.approved);
    int sum(Iterable<TxItem> l) => l.fold<int>(0, (s, t) => s + t.amount);
    return FinanceSummary(
      totalIncome: sum(approved.where((t) => t.isIncome)),
      totalExpense: sum(approved.where((t) => !t.isIncome)),
      bazarTotal: sum(approved.where((t) => t.type == TxType.bazar)),
    );
  }
}
