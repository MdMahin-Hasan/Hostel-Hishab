import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/extensions/context_extensions.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/utils/formatters.dart';
import 'package:hostel_hisab/core/widgets/app_card.dart';
import 'package:hostel_hisab/core/widgets/empty_view.dart';
import 'package:hostel_hisab/core/widgets/state_view.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/presentation/providers/finance_provider.dart';
import 'package:hostel_hisab/features/finance/presentation/widgets/tx_tile.dart';
import 'package:provider/provider.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  Future<void> _approve(BuildContext context, FinanceProvider p, String id) async {
    await p.approve(id);
    if (!context.mounted) return;
    if (p.error != null) {
      context.toast(p.error!, isError: true);
    } else {
      context.toast('জমা অনুমোদিত হয়েছে');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<FinanceProvider>();
    final items = p.filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('হিসাব'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          const SizedBox(width: 8),
        ],
      ),
      body: StateView(
        state: p.state,
        hasData: p.transactions.isNotEmpty,
        error: p.error,
        onRetry: p.load,
        // builder: item 0 = summary + filters, then one row per transaction
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: items.isEmpty ? 2 : items.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) return _Header(p: p);
            if (items.isEmpty) {
              return const EmptyView(
                icon: Icons.receipt_long_outlined,
                title: 'কোনো লেনদেন নেই',
                message: 'জমা বা বাজার যোগ করলে এখানে দেখা যাবে',
              );
            }
            final tx = items[i - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TxTile(
                  tx: tx,
                  // later: pass this only when the user is a manager
                  onApprove: tx.status == TxStatus.pending
                      ? () => _approve(context, p, tx.id)
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.p});
  final FinanceProvider p;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _Summary('মোট জমা', p.totalIncome, AppColors.primary),
            const SizedBox(width: 10),
            _Summary('মোট খরচ', p.totalExpense, AppColors.danger),
          ]),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('অবশিষ্ট ব্যালেন্স',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text(Fmt.taka(p.balance),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: [
              for (final f in TxFilter.values)
                ChoiceChip(
                  label: Text(f.label),
                  selected: p.filter == f,
                  onSelected: (_) => p.setFilter(f),
                  showCheckmark: false,
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.primary,
                  side: BorderSide(color: p.filter == f ? AppColors.primary : AppColors.line),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: p.filter == f ? Colors.white : AppColors.ink,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary(this.label, this.amount, this.color);
  final String label;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(Fmt.taka(amount),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          ),
        ]),
      ),
    );
  }
}
