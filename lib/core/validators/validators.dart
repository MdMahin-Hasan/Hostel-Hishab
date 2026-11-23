import 'package:hostel_hisab/core/utils/formatters.dart';

/// Form validators: return an error text, or null when the value is OK.
/// Usage: TextFormField(validator: Validators.amount)
class Validators {
  static String? requiredField(String? v, [String message = 'এটি লেখা আবশ্যক']) =>
      (v == null || v.trim().isEmpty) ? message : null;

  /// Accepts Bangla or English digits (১২৫০ or 1250).
  static String? amount(String? v) {
    final n = Fmt.parseInt(v);
    return (n == null || n <= 0) ? 'সঠিক পরিমাণ লিখুন' : null;
  }

  static String? phone(String? v) {
    final s = Fmt.en((v ?? '').trim());
    return RegExp(r'^01[3-9]\d{8}$').hasMatch(s) ? null : 'সঠিক মোবাইল নম্বর লিখুন';
  }
}
