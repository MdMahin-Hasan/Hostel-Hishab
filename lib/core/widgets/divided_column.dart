import 'package:flutter/material.dart';
import 'package:hostel_hisab/core/theme/app_colors.dart';

/// A Column with a thin divider between children (no more manual loops).
class DividedColumn extends StatelessWidget {
  const DividedColumn({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: AppColors.line),
          children[i],
        ],
      ],
    );
  }
}
