import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';

/// Uses StatsCardLayout from lux_blocks for spending overview
class SpendingOverview extends StatelessWidget {
  const SpendingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ภาพรวมเดือนนี้', style: AppTextStyles.h4(color: fg)),
        const SizedBox(height: 12),
        const StatsCardLayout(),
      ],
    );
  }
}
