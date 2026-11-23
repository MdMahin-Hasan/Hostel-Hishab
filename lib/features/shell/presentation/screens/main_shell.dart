import 'package:flutter/material.dart';
import 'package:hostel_hisab/app/routes.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/features/finance/presentation/screens/finance_screen.dart';
import 'package:hostel_hisab/features/home/presentation/screens/home_screen.dart';
import 'package:hostel_hisab/features/meals/presentation/screens/meals_screen.dart';
import 'package:hostel_hisab/features/profile/presentation/screens/profile_screen.dart';

/// Holds the bottom navigation + the 4 tab screens.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goTo(int i) => setState(() => _index = i);

  void _showQuickAdd() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
            title: const Text('জমা দিন'),
            onTap: () {
              Navigator.pop(sheetContext);
              Navigator.pushNamed(context, AppRoutes.deposit);
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_outlined, color: AppColors.orange),
            title: const Text('মিল এন্ট্রি'),
            onTap: () {
              Navigator.pop(sheetContext);
              _goTo(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined, color: AppColors.purple),
            title: const Text('বাজার এন্ট্রি (নিজে বানান!)'),
            onTap: () => Navigator.pop(sheetContext),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's scroll position alive.
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onGoToTab: _goTo),
          const MealsScreen(),
          const FinanceScreen(),
          const ProfileScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickAdd,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(Icons.home_outlined, 'হোম', _index == 0, () => _goTo(0)),
            _NavItem(Icons.restaurant_outlined, 'মিল', _index == 1, () => _goTo(1)),
            const SizedBox(width: 56), // space for the + button
            _NavItem(Icons.account_balance_wallet_outlined, 'হিসাব', _index == 2, () => _goTo(2)),
            _NavItem(Icons.person_outline, 'প্রোফাইল', _index == 3, () => _goTo(3)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(this.icon, this.label, this.active, this.onTap);
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.muted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
