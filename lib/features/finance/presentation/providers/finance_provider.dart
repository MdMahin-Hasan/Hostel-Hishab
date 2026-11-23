import 'package:hostel_hisab/core/base/base_provider.dart';
import 'package:hostel_hisab/features/finance/domain/entities/finance_summary.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/add_deposit.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/approve_deposit.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/calculate_meal_rate.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/calculate_summary.dart';
import 'package:hostel_hisab/features/finance/domain/usecases/get_transactions.dart';

enum TxFilter {
  all('সব'),
  bazar('বাজার'),
  deposit('জমা'),
  withdraw('তোলা');

  const TxFilter(this.label);
  final String label;
}

/// The provider only coordinates: call usecase -> keep result -> notify UI.
/// All money rules live in domain/usecases.
class FinanceProvider extends BaseProvider {
  FinanceProvider({
    required GetTransactions getTransactions,
    required AddDeposit addDeposit,
    required ApproveDeposit approveDeposit,
    required CalculateSummary calculateSummary,
    required CalculateMealRate calculateMealRate,
  })  : _getTransactions = getTransactions,
        _addDeposit = addDeposit,
        _approveDeposit = approveDeposit,
        _calculateSummary = calculateSummary,
        _calculateMealRate = calculateMealRate;

  final GetTransactions _getTransactions;
  final AddDeposit _addDeposit;
  final ApproveDeposit _approveDeposit;
  final CalculateSummary _calculateSummary;
  final CalculateMealRate _calculateMealRate;

  List<TxItem> _txs = [];
  FinanceSummary _summary = const FinanceSummary();
  TxFilter _filter = TxFilter.all;

  List<TxItem> get transactions => _txs;
  TxFilter get filter => _filter;

  int get totalIncome => _summary.totalIncome;
  int get totalExpense => _summary.totalExpense;
  int get bazarTotal => _summary.bazarTotal;
  int get balance => _summary.balance;

  double mealRate(int totalMeals) =>
      _calculateMealRate(bazarTotal: bazarTotal, totalMeals: totalMeals);

  List<TxItem> get filtered => _txs.where((t) {
        switch (_filter) {
          case TxFilter.all:
            return true;
          case TxFilter.bazar:
            return t.type == TxType.bazar;
          case TxFilter.deposit:
            return t.isIncome;
          case TxFilter.withdraw:
            return t.type == TxType.withdraw;
        }
      }).toList();

  void _setTxs(List<TxItem> list) {
    _txs = list;
    _summary = _calculateSummary(list);
  }

  void setFilter(TxFilter f) {
    _filter = f;
    notifyListeners();
  }

  Future<void> load() => run(() async {
        _setTxs(await _getTransactions());
      });

  Future<bool> addDeposit({
    required int amount,
    required PaymentMethod method,
    String? trxId,
  }) async {
    await run(() async {
      final tx = await _addDeposit(amount: amount, method: method, trxId: trxId);
      _setTxs([tx, ..._txs]);
    });
    return state == ViewState.success;
  }

  Future<void> approve(String id) => run(() async {
        final updated = await _approveDeposit(id);
        _setTxs([for (final t in _txs) t.id == id ? updated : t]);
      });
}
