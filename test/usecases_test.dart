import 'package:flutter_test/flutter_test.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/calculate_meal_rate.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/calculate_summary.dart';

// Pure usecases need NO mocks and NO Flutter: the easiest tests to write.
void main() {
  test('CalculateSummary ignores pending and splits income/expense', () {
    final txs = [
      TxItem(id: '1', title: 'বাজার', who: 'a', date: DateTime(2026, 10, 1), amount: 500, type: TxType.bazar),
      TxItem(id: '2', title: 'জমা', who: 'a', date: DateTime(2026, 10, 1), amount: 2000, type: TxType.deposit),
      TxItem(id: '3', title: 'জমা', who: 'a', date: DateTime(2026, 10, 1), amount: 999, type: TxType.deposit, status: TxStatus.pending),
    ];
    final s = const CalculateSummary()(txs);
    expect(s.totalIncome, 2000);
    expect(s.totalExpense, 500);
    expect(s.bazarTotal, 500);
    expect(s.balance, 1500);
  });

  test('CalculateMealRate = bazar / meals, safe when meals is 0', () {
    const calc = CalculateMealRate();
    expect(calc(bazarTotal: 9500, totalMeals: 1020).toStringAsFixed(2), '9.31');
    expect(calc(bazarTotal: 9500, totalMeals: 0), 0);
  });
}
