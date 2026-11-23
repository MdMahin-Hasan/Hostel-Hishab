import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    const padding = EdgeInsets.symmetric(vertical: 14);
    const textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    final action = loading ? null : onPressed;

    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: action,
              style: OutlinedButton.styleFrom(
                padding: padding,
                shape: shape,
                textStyle: textStyle,
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              child: Text(label),
            )
          : FilledButton(
              onPressed: action,
              style: FilledButton.styleFrom(
                padding: padding,
                shape: shape,
                textStyle: textStyle,
                backgroundColor: AppColors.primary,
              ),
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(label),
            ),
    );
  }
}
