import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/base/base_provider.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';

/// Shows spinner / error+retry / your content, based on a provider's state.
/// If data is already on screen, it keeps showing it (no flicker on refresh).
class StateView extends StatelessWidget {
  const StateView({
    super.key,
    required this.state,
    required this.hasData,
    required this.child,
    this.error,
    this.onRetry,
  });

  final ViewState state;
  final bool hasData;
  final Widget child;
  final String? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (state == ViewState.loading && !hasData) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state == ViewState.error && !hasData) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error ?? 'কিছু ভুল হয়েছে',
                style: const TextStyle(color: AppColors.muted)),
            TextButton(onPressed: onRetry, child: const Text('আবার চেষ্টা করুন')),
          ],
        ),
      );
    }
    return child;
  }
}
