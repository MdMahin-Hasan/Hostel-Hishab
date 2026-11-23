import 'package:flutter_test/flutter_test.dart';
import 'package:hostel_hisab/features/finance/data/datasources/mock_finance_datasource.dart';
import 'package:hostel_hisab/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/add_deposit.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/approve_deposit.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/calculate_meal_rate.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/calculate_summary.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/get_transactions.dart';
import 'package:hostel_hisab/features/finance/presentation/providers/finance_provider.dart';

FinanceProvider _makeProvider() {
  final repo = FinanceRepositoryImpl(MockFinanceDataSource());
  return FinanceProvider(
    getTransactions: GetTransactions(repo),
    addDeposit: AddDeposit(repo),
    approveDeposit: ApproveDeposit(repo),
    calculateSummary: const CalculateSummary(),
    calculateMealRate: const CalculateMealRate(),
  );
}

void main() {
  test('pending deposit is not counted until approved', () async {
    final p = _makeProvider();
    await p.load();
    final before = p.balance;

    await p.addDeposit(amount: 1000, method: PaymentMethod.bkash, trxId: 'ABC123');
    expect(p.balance, before); // pending -> not counted

    final pendingId = p.transactions.first.id;
    await p.approve(pendingId);
    expect(p.balance, before + 1000); // approved -> counted
  });

  test('bkash deposit without TrxID is rejected', () async {
    final p = _makeProvider();
    await p.load();
    final ok = await p.addDeposit(amount: 500, method: PaymentMethod.bkash);
    expect(ok, false);
    expect(p.error, isNotNull);
  });
}
