/// Result of the money calculation (pure data).
class FinanceSummary {
  const FinanceSummary({
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.bazarTotal = 0,
  });

  final int totalIncome, totalExpense, bazarTotal;
  int get balance => totalIncome - totalExpense;
}
