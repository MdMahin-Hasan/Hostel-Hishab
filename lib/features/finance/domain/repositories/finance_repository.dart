import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';

abstract class FinanceRepository {
  Future<List<TxItem>> getTransactions();
  Future<TxItem> addDeposit({
    required int amount,
    required PaymentMethod method,
    String? trxId,
  });
  Future<TxItem> approveDeposit(String id);
}
