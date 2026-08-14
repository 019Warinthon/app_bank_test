// lib/shared/widgets/amount_text.dart
// Reusable widget: displays a formatted currency amount with sign & color.

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';

class AmountText extends StatelessWidget {
  final double amount;
  final bool isIncome;
  final double? fontSize;
  final bool showSign;

  const AmountText({
    super.key,
    required this.amount,
    required this.isIncome,
    this.fontSize,
    this.showSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome
        ? const Color(0xFF10B981) // success green
        : const Color(0xFFEF4444); // destructive red
    final prefix = !showSign
        ? ''
        : isIncome
            ? '+'
            : '-';

    return Text(
      '$prefix฿${_fmt(amount.abs())}',
      style: AppTextStyles.label(color: color).copyWith(
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
      ),
    );
  }

  static String _fmt(double v) {
    final parts = v.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }
}
