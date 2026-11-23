enum TxType { bazar, deposit, withdraw, refund, settlement }

enum TxStatus { pending, approved }

enum PaymentMethod {
  bkash('বিকাশ', 'মোবাইল ব্যাংকিং'),
  bank('ব্যাংক ট্রান্সফার', 'অ্যাকাউন্ট নম্বর দিয়ে'),
  cash('নগদ হাতে', 'ম্যানেজার নিশ্চিত করবেন');

  const PaymentMethod(this.label, this.subtitle);
  final String label, subtitle;

  /// bKash and bank payments need a reference so the manager can verify.
  bool get needsTrxId => this != PaymentMethod.cash;
}

class TxItem {
  const TxItem({
    required this.id,
    required this.title,
    required this.who,
    required this.date,
    required this.amount,
    required this.type,
    this.status = TxStatus.approved,
    this.method,
    this.trxId,
  });

  final String id, title, who;
  final DateTime date;
  final int amount; // whole taka
  final TxType type;
  final TxStatus status;
  final PaymentMethod? method;
  final String? trxId;

  bool get isIncome =>
      type == TxType.deposit || type == TxType.refund || type == TxType.settlement;
}
