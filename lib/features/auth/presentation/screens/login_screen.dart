import 'package:flutter/material.dart';
import 'package:hostel_hisab/app/routes.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/widgets/primary_button.dart';
import 'package:hostel_hisab/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _id = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final navigator = Navigator.of(context);
    final ok = await context.read<AuthProvider>().login(_id.text, _password.text);
    if (ok) navigator.pushReplacementNamed(AppRoutes.shell);
  }

  @override
  Widget build(BuildContext context) {
    // watch = rebuild when provider changes (loading / error text)
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 72, 24, 36),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.teal, AppColors.blue],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.apartment_rounded, color: Colors.white, size: 48),
                SizedBox(height: 14),
                Text('হোস্টেল হিসাব',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700)),
                Text('মিল, বাজার ও জমার সহজ হিসাব',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('স্বাগতম!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                TextField(
                  controller: _id,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'মোবাইল নম্বর বা ইমেইল',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'পাসওয়ার্ড',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                if (auth.error != null) ...[
                  const SizedBox(height: 10),
                  Text(auth.error!,
                      style: const TextStyle(color: AppColors.danger)),
                ],
                const SizedBox(height: 20),
                PrimaryButton(
                    label: 'লগইন', loading: auth.isLoading, onPressed: _login),
                const SizedBox(height: 12),
                PrimaryButton(label: 'OTP দিয়ে লগইন', outlined: true, onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
