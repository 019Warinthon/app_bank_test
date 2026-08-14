// lib/features/transactions/widgets/transaction_tile.dart
// Widget ที่ใช้ซ้ำใน transactions screen และ dashboard

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  final bool compact;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.tx,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg    = isDark ? AppColors.foregroundDark    : AppColors.foregroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppColors.radiusMd),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: compact ? 8 : 12),
        child: Row(
          children: [
            // icon
            Container(
              width: compact ? 36 : 42,
              height: compact ? 36 : 42,
              decoration: BoxDecoration(
                color: tx.categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppColors.radiusMd),
              ),
              child: Icon(tx.categoryIcon, color: tx.categoryColor,
                  size: compact ? 16 : 20),
            ),
            const SizedBox(width: 12),

            // title + desc
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.title,
                      style: AppTextStyles.label(color: fg)
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (!compact && tx.description != null) ...[
                    const SizedBox(height: 2),
                    Text(tx.description!,
                        style: AppTextStyles.caption(color: muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),

            // amount + time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tx.formattedAmount,
                  style: AppTextStyles.label(color: tx.amountColor).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 12 : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _relTime(tx.date),
                  style: AppTextStyles.caption(color: muted)
                      .copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _relTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes} นาทีก่อน';
    if (diff.inHours  < 24) return '${diff.inHours} ชม. ก่อน';
    if (diff.inDays   == 1) return 'เมื่อวาน';
    if (diff.inDays   <  7) return '${diff.inDays} วันก่อน';
    return '${d.day}/${d.month}/${d.year}';
  }
}
