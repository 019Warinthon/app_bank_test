// lib/shared/widgets/app_empty_state.dart
// Reusable widget: empty state placeholder (no data / no results).

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.chartIndigo.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.chartIndigo, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.h4(color: fg),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: AppTextStyles.bodySmall(color: muted),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              BlocksButton(
                label: actionLabel!,
                onPressed: onAction!,
                variant: BlocksButtonVariant.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
