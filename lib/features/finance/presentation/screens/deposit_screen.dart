import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/extensions/context_extensions.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';
import 'package:hostel_hisab/core/utils/formatters.dart';
import 'package:hostel_hisab/core/validators/validators.dart';
import 'package:hostel_hisab/core/widgets/app_card.dart';
import 'package:hostel_hisab/core/widgets/primary_button.dart';
import 'package:hostel_hisab/features/finance/domain/entities/tx_item.dart';
import 'package:hostel_hisab/features/finance/presentation/providers/finance_provider.dart';
import 'package:provider/provider.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _trx = TextEditingController();
  PaymentMethod _method = PaymentMethod.bkash;

  @override
  void dispose() {
    _amount.dispose();
    _trx.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final finance = context.read<FinanceProvider>();
    final ok = await finance.addDeposit(
      amount: Fmt.parseInt(_amount.text)!, // validator already checked it
      method: _method,
      trxId: _trx.text.trim(),
    );
    if (!ok) {
      messenger.toast(finance.error ?? 'আবার চেষ্টা করুন', isError: true);
      return;
    }
    navigator.pop();
    messenger.toast('জমার অনুরোধ পাঠানো হয়েছে। ম্যানেজার অনুমোদন করবেন।');
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<FinanceProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('জমা দিন')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _amount,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary),
              decoration: const InputDecoration(labelText: 'পরিমাণ (৳)'),
              validator: Validators.amount,
            ),
            const SizedBox(height: 18),
            const Text('পেমেন্ট মাধ্যম', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (final m in PaymentMethod.values) ...[
              _MethodTile(
                method: m,
                selected: _method == m,
                onTap: () => setState(() => _method = m),
              ),
              const SizedBox(height: 8),
            ],
            if (_method.needsTrxId) ...[
              const SizedBox(height: 6),
              TextFormField(
                controller: _trx,
                decoration: InputDecoration(
                  labelText: _method == PaymentMethod.bkash
                      ? 'ট্রানজেকশন আইডি (TrxID)'
                      : 'ব্যাংক রেফারেন্স নম্বর',
                ),
                validator: Validators.requiredField,
              ),
            ],
            const SizedBox(height: 20),
            PrimaryButton(label: 'জমার অনুরোধ পাঠান', loading: loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({required this.method, required this.selected, required this.onTap});
  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: selected ? AppColors.primary : AppColors.line,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(method.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(method.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ]),
        ),
        Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.primary : AppColors.line),
      ]),
    );
  }
}
