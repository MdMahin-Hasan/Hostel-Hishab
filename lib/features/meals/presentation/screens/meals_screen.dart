import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/extensions/context_extensions.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/utils/formatters.dart';
import 'package:hostel_hisab/core/widgets/app_card.dart';
import 'package:hostel_hisab/core/widgets/empty_view.dart';
import 'package:hostel_hisab/core/widgets/primary_button.dart';
import 'package:hostel_hisab/core/widgets/state_view.dart';
import 'package:hostel_hisab/features/meals/domain/entities/meal_entry.dart';
import 'package:hostel_hisab/features/meals/presentation/providers/meals_provider.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  Future<void> _save(BuildContext context, MealsProvider p) async {
    await p.save();
    if (!context.mounted) return;
    if (p.error == null) {
      context.toast('মিল সংরক্ষিত হয়েছে');
    } else {
      context.toast(p.error!, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MealsProvider>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('দৈনিক মিল'),
            Text(Fmt.date(DateTime.now()),
                style: const TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      body: StateView(
        state: p.state,
        hasData: p.entries.isNotEmpty,
        error: p.error,
        onRetry: p.load,
        child: p.entries.isEmpty
            ? const EmptyView(
                icon: Icons.restaurant_outlined,
                title: 'আজকের জন্য কোনো সদস্য নেই',
                message: 'আগে সদস্য যোগ করুন, তারপর মিল লিখুন',
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (final t in MealType.values)
                            Column(children: [
                              Text(Fmt.bn(p.total(t)),
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                              Text(t.label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                            ]),
                        ],
                      ),
                    ),
                  ),
                  // builder: only visible member cards are built
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: p.entries.length,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MemberMealCard(entry: p.entries[i]),
                      ),
                    ),
                  ),
                  // Save button stays pinned at the bottom
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: PrimaryButton(
                      label: 'সংরক্ষণ করুন',
                      loading: p.isLoading,
                      onPressed: p.isDirty ? () => _save(context, p) : null,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _MemberMealCard extends StatelessWidget {
  const _MemberMealCard({required this.entry});
  final MealEntry entry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.memberName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text('রুম ${entry.room}', style: const TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            for (final t in MealType.values)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _MealToggle(
                    label: t.label,
                    selected: entry.has(t),
                    // read: we only CALL a method here
                    onTap: () => context.read<MealsProvider>().toggle(entry.memberId, t),
                  ),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}

class _MealToggle extends StatelessWidget {
  const _MealToggle({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.primary : AppColors.line),
        ),
        child: Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.muted,
            )),
      ),
    );
  }
}
