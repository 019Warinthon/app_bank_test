// lib/features/dashboard/widgets/recent_transactions.dart
// Dashboard widget: shows the 5 most recent transactions.
// Uses: TransactionService (data) + TransactionTile (shared widget)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lux_blocks/lux_blocks.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_section_header.dart';
import '../../transactions/services/transaction_service.dart';
import '../../transactions/widgets/transaction_tile.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    final txService = TransactionService.instance;
    final recent = txService.getRecent(5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'รายการล่าสุด',
          actionLabel: 'ดูทั้งหมด →',
          onAction: () => context.go('/transactions'),
        ),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          const AppEmptyState(
            icon: Icons.receipt_long_rounded,
            title: 'ยังไม่มีรายการ',
          )
        else
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
              separatorBuilder: (_, index) => Divider(color: border, height: 1),
              itemBuilder: (_, i) => TransactionTile(
                tx: recent[i],
                compact: false,
              ),
            ),
          ),
      ],
    );
  }
}
