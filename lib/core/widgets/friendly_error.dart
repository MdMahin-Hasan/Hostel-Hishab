import 'package:flutter/material.dart';

/// Shown in RELEASE builds instead of Flutter's red/grey error screen.
class FriendlyError extends StatelessWidget {
  const FriendlyError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'কিছু একটা সমস্যা হয়েছে।\nঅ্যাপটি আবার চালু করুন।',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
