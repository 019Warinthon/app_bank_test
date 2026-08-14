import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/transaction_model.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted =
        isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    final recent = MockData.transactions.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('รายการล่าสุด', style: AppTextStyles.h4(color: fg)),
            TextButton(
              onPressed: () => context.go('/transactions'),
              child: Text(
                'ดูทั้งหมด →',
                style: AppTextStyles.bodySmall(color: AppColors.chartIndigo),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppColors.radiusXl),
            border: Border.all(color: border),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: recent.length,
            separatorBuilder: (_, _) => Divider(color: border, height: 1),
            itemBuilder: (context, index) {
              final tx = recent[index];
              return _TransactionTile(transaction: tx, fg: fg, muted: muted);
            },
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final Color fg;
  final Color muted;

  const _TransactionTile({
    required this.transaction,
    required this.fg,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final amountColor = isIncome ? AppColors.success : AppColors.destructiveLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(transaction.category).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
            ),
            child: Icon(
              _getCategoryIcon(transaction.category),
              color: _getCategoryColor(transaction.category),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: AppTextStyles.label(color: fg),
                ),
                if (transaction.description != null)
                  Text(
                    transaction.description!,
                    style: AppTextStyles.caption(color: muted),
                  ),
              ],
            ),
          ),
          Text(
            transaction.formattedAmount,
            style: AppTextStyles.label(color: amountColor).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    return switch (category) {
      TransactionCategory.salary => LucideIcons.briefcase,
      TransactionCategory.food => LucideIcons.utensils,
      TransactionCategory.transport => LucideIcons.train,
      TransactionCategory.shopping => LucideIcons.shoppingBag,
      TransactionCategory.bills => LucideIcons.fileText,
      TransactionCategory.entertainment => LucideIcons.gamepad2,
      TransactionCategory.health => LucideIcons.heartPulse,
      TransactionCategory.education => LucideIcons.graduationCap,
      TransactionCategory.transfer => LucideIcons.arrowLeftRight,
      TransactionCategory.topUp => LucideIcons.smartphone,
      TransactionCategory.other => LucideIcons.circle,
    };
  }

  Color _getCategoryColor(TransactionCategory category) {
    return switch (category) {
      TransactionCategory.salary => AppColors.success,
      TransactionCategory.food => AppColors.chartOrange,
      TransactionCategory.transport => AppColors.chartCyan,
      TransactionCategory.shopping => AppColors.chartPurple,
      TransactionCategory.bills => AppColors.chartAmber,
      TransactionCategory.entertainment => AppColors.chartIndigo,
      TransactionCategory.health => AppColors.chartRed,
      TransactionCategory.education => AppColors.chartBlue,
      TransactionCategory.transfer => AppColors.chartIndigo,
      TransactionCategory.topUp => AppColors.chartGreen,
      TransactionCategory.other => AppColors.chartNeutral,
    };
  }
}
