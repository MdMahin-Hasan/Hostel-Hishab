import 'package:hostel_hisab/core/errors/app_exception.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/domain/repositories/finance_repository.dart';

class AddDeposit {
  const AddDeposit(this._repo);
  final FinanceRepository _repo;

  Future<TxItem> call({
    required int amount,
    required PaymentMethod method,
    String? trxId,
  }) {
    if (amount <= 0) throw const AppException('সঠিক পরিমাণ লিখুন');
    if (method.needsTrxId && (trxId == null || trxId.trim().isEmpty)) {
      throw const AppException('ট্রানজেকশন আইডি আবশ্যক');
    }
    return _repo.addDeposit(amount: amount, method: method, trxId: trxId?.trim());
  }
}
