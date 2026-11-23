import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';

/// One place for snackbars. Use:
///   context.toast('সংরক্ষিত হয়েছে');
///   context.toast(provider.error!, isError: true);
/// If you must show it after the screen closes, capture the messenger first:
///   final messenger = ScaffoldMessenger.of(context);  ...  messenger.toast('...');
extension MessengerX on ScaffoldMessengerState {
  void toast(String message, {bool isError = false}) {
    hideCurrentSnackBar();
    showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? AppColors.danger : null,
    ));
  }
}

extension ContextX on BuildContext {
  void toast(String message, {bool isError = false}) =>
      ScaffoldMessenger.of(this).toast(message, isError: isError);
}
