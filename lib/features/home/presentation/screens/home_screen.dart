import 'package:flutter/material.dart';
import 'package:hostel_hisab/app/routes.dart';
import 'package:hostel_hisab/core/extensions/context_extensions.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/utils/formatters.dart';
import 'package:hostel_hisab/core/widgets/app_card.dart';
import 'package:hostel_hisab/core/widgets/divided_column.dart';
import 'package:hostel_hisab/core/widgets/empty_view.dart';
import 'package:hostel_hisab/core/widgets/initial_avatar.dart';
import 'package:hostel_hisab/features/auth/presentation/providers/auth_provider.dart';
import 'package:hostel_hisab/features/finance/presentation/providers/finance_provider.dart';
import 'package:hostel_hisab/features/finance/presentation/widgets/tx_tile.dart';
import 'package:hostel_hisab/features/meals/presentation/providers/meals_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onGoToTab});

  /// The shell gives us a function to switch tabs.
  final ValueChanged<int> onGoToTab;

  void _soon(BuildContext context) =>
      context.toast('এই স্ক্রিনটি আপনি বানান - README দেখুন');

  @override
  Widget build(BuildContext context) {
    // Home reads THREE providers - that is normal in Provider apps.
    final auth = context.watch<AuthProvider>();
    final fin = context.watch<FinanceProvider>();
    final meals = context.watch<MealsProvider>();

    final double rate = fin.mealRate(meals.monthTotalMeals);
    final firstName = auth.userName.split(' ').first;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 16,
        title: Row(children: [
          InitialAvatar(name: auth.userName, color: AppColors.primary, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('সবুজ ছাত্রাবাস',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w400)),
                Text('আসসালামু আলাইকুম, $firstName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ]),
        actions: [
          IconButton(
            onPressed: () => _soon(context),
            style: IconButton.styleFrom(backgroundColor: AppColors.background),
            icon: const Badge(label: Text('৪'), child: Icon(Icons.notifications_outlined)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Balance hero
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('মোট ব্যালেন্স', style: TextStyle(color: Colors.white70)),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(Fmt.taka(fin.balance),
                    style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 14),
              Row(children: [
                _HeroStat('জমা', fin.totalIncome),
                const SizedBox(width: 10),
                _HeroStat('খরচ', fin.totalExpense),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          // Quick actions (each has its own colour)
          Row(children: [
            _Quick(Icons.account_balance_wallet_outlined, 'জমা দিন', AppColors.primary, AppColors.greenSoft,
                () => Navigator.pushNamed(context, AppRoutes.deposit)),
            _Quick(Icons.restaurant_outlined, 'মিল', AppColors.blue, AppColors.blueSoft, () => onGoToTab(1)),
            _Quick(Icons.shopping_bag_outlined, 'বাজার', AppColors.orange, AppColors.orangeSoft, () => _soon(context)),
            _Quick(Icons.people_outline, 'সদস্য', AppColors.purple, AppColors.purpleSoft,
                () => Navigator.pushNamed(context, AppRoutes.members)),
          ]),
          const SizedBox(height: 16),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('এই মাসের মিল রেট',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  Text('৳ ${Fmt.bn(rate.toStringAsFixed(2))}',
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'মোট বাজার ${Fmt.taka(fin.bazarTotal)} · মোট মিল ${Fmt.bn(Fmt.group(meals.monthTotalMeals))}',
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('সাম্প্রতিক লেনদেন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            TextButton(onPressed: () => onGoToTab(2), child: const Text('সব দেখুন')),
          ]),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: fin.transactions.isEmpty
                ? const EmptyView(
                    icon: Icons.receipt_long_outlined,
                    title: 'এখনো কোনো লেনদেন নেই',
                    compact: true,
                  )
                : DividedColumn(children: [
                    for (final tx in fin.transactions.take(3)) TxTile(tx: tx),
                  ]),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat(this.label, this.amount);
  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0x29FFFFFF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(Fmt.taka(amount),
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick(this.icon, this.label, this.color, this.soft, this.onTap);
  final IconData icon;
  final String label;
  final Color color, soft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: soft, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
