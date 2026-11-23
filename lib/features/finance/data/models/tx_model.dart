import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';

class TxModel extends TxItem {
  const TxModel({
    required super.id,
    required super.title,
    required super.who,
    required super.date,
    required super.amount,
    required super.type,
    super.status = TxStatus.approved,
    super.method,
    super.trxId,
  });

  factory TxModel.fromJson(Map<String, dynamic> json) => TxModel(
        id: json['_id'] as String,
        title: json['title'] as String,
        who: json['who'] as String,
        date: DateTime.parse(json['date'] as String),
        amount: (json['amount'] as num).toInt(),
        type: TxType.values.byName(json['type'] as String),
        status: TxStatus.values.byName(json['status'] as String? ?? 'approved'),
        method: json['method'] == null
            ? null
            : PaymentMethod.values.byName(json['method'] as String),
        trxId: json['trxId'] as String?,
      );
}
