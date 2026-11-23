import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/utils/formatters.dart';
import 'package:hostel_hisab/core/widgets/status_chip.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';

/// One transaction row. Used on Home AND Finance (reuse = less code).
class TxTile extends StatelessWidget {
  const TxTile({super.key, required this.tx, this.onApprove});
  final TxItem tx;

  /// Only passed for pending items when the user is a manager.
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) {
    final income = tx.isIncome;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tx.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            Text('${Fmt.date(tx.date)} · ${tx.who}',
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          // sign + colour: never rely on colour alone
          Text('${income ? '+' : '−'} ${Fmt.taka(tx.amount)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: income ? AppColors.primary : AppColors.danger,
              )),
          if (tx.status == TxStatus.pending)
            const StatusChip(
                label: 'অপেক্ষমাণ', color: AppColors.orange, background: AppColors.orangeSoft),
          if (tx.status == TxStatus.pending && onApprove != null)
            TextButton(
              onPressed: onApprove,
              style: TextButton.styleFrom(
                  minimumSize: const Size(0, 30), padding: const EdgeInsets.symmetric(horizontal: 8)),
              child: const Text('অনুমোদন করুন'),
            ),
        ]),
      ]),
    );
  }
}
