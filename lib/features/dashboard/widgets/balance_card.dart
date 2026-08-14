// lib/features/dashboard/widgets/balance_card.dart

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import '../services/account_service.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final svc      = AccountService.instance;
    final total    = svc.getTotalBalance();
    final accounts = svc.getDepositAccounts();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusXl),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ยอดเงินคงเหลือ',
                  style: AppTextStyles.bodySmall(
                      color: Colors.white.withValues(alpha: 0.8))),
              _ActiveBadge(),
            ],
          ),
          const SizedBox(height: 12),
          Text('฿${_fmt(total)}',
              style: AppTextStyles.h1(color: Colors.white).copyWith(
                  fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -1)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.trending_up_rounded,
                color: Color(0xFF10B981), size: 16),
            const SizedBox(width: 4),
            Text('+12.5% จากเดือนก่อน',
                style: AppTextStyles.caption(
                    color: Colors.white.withValues(alpha: 0.8))),
          ]),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8, runSpacing: 6,
            children: accounts.map((a) => _AccountChip(name: a.name, masked: a.maskedNumber)).toList(),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    final p = v.toStringAsFixed(2).split('.');
    final n = p[0].replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '$n.${p[1]}';
  }
}

class _ActiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(AppColors.radiusFull),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 6, height: 6,
          decoration: const BoxDecoration(
              color: Color(0xFF10B981), shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text('Active', style: AppTextStyles.caption(color: Colors.white)),
    ]),
  );
}

class _AccountChip extends StatelessWidget {
  final String name;
  final String masked;
  const _AccountChip({required this.name, required this.masked});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(AppColors.radiusFull),
      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
    ),
    child: Text('$name $masked',
        style: AppTextStyles.caption(color: Colors.white)),
  );
}
