import 'package:flutter/material.dart';
import 'package:hostel_hisab/app/routes.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/widgets/app_card.dart';
import 'package:hostel_hisab/core/widgets/primary_button.dart';
import 'package:hostel_hisab/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('প্রোফাইল')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.purple, AppColors.pink]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: Color(0x40FFFFFF),
                child: Icon(Icons.person, color: Colors.white, size: 34),
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(auth.userName,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0x38FFFFFF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('ম্যানেজার',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(children: [
              const _Tile(Icons.language, 'ভাষা', AppColors.blue, AppColors.blueSoft, trailing: 'বাংলা'),
              const Divider(height: 1, color: AppColors.line),
              const _Tile(Icons.apartment_rounded, 'হোস্টেল সেটিংস', AppColors.primary, AppColors.greenSoft),
              const Divider(height: 1, color: AppColors.line),
              _Tile(Icons.people_outline, 'সদস্য ম্যানেজ', AppColors.purple, AppColors.purpleSoft,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.members)),
              const Divider(height: 1, color: AppColors.line),
              const _Tile(Icons.payments_outlined, 'পেমেন্ট মাধ্যম', AppColors.pink, AppColors.pinkSoft,
                  trailing: 'বিকাশ, ব্যাংক'),
            ]),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'লগআউট',
            outlined: true,
            onPressed: () async {
              final navigator = Navigator.of(context);
              await context.read<AuthProvider>().logout();
              navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
            },
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.title, this.color, this.soft, {this.trailing, this.onTap});
  final IconData icon;
  final String title;
  final Color color, soft;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: soft, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          if (trailing != null)
            Text(trailing!, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          const Icon(Icons.chevron_right, color: AppColors.muted),
        ]),
      ),
    );
  }
}
