// lib/features/dashboard/widgets/balance_card.dart

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../profile/widgets/pin_auth_sheet.dart';
import '../models/account_model.dart';
import '../services/account_service.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceHidden = false;

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
          // ── Header Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'ยอดเงินคงเหลือรวม',
                    style: AppTextStyles.bodySmall(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isBalanceHidden = !_isBalanceHidden),
                    child: Icon(
                      _isBalanceHidden ? LucideIcons.eyeOff : LucideIcons.eye,
                      color: Colors.white.withValues(alpha: 0.85),
                      size: 16,
                    ),
                  ),
                ],
              ),
              _ActiveBadge(),
            ],
          ),
          const SizedBox(height: 12),

          // ── Balance Display ──
          Text(
            _isBalanceHidden ? '฿ ••••••••' : '฿${_fmt(total)}',
            style: AppTextStyles.h1(color: Colors.white).copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: Color(0xFF10B981), size: 16),
              const SizedBox(width: 4),
              Text(
                '+12.5% จากเดือนก่อน',
                style: AppTextStyles.caption(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Account Chips with PIN Protected Details ──
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: accounts.map((acc) {
              return _AccountChip(
                account: acc,
                onTap: () => _showAccountDetailsWithAuth(context, acc),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _showAccountDetailsWithAuth(BuildContext context, AccountModel account) async {
    final authenticated = await PinAuthSheet.show(
      context,
      title: 'ยืนยันตัวตนเพื่อดูข้อมูลบัญชี',
      subtitle: 'กรุณากรอกรหัส PIN หรือสแกนเพื่อดูเลขบัญชีเต็มและยอดเงิน',
    );

    if (authenticated && context.mounted) {
      _showAccountDetailsModal(context, account);
    }
  }

  void _showAccountDetailsModal(BuildContext context, AccountModel account) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
        final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
        final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
        final border = isDark ? AppColors.borderDark : AppColors.borderLight;

        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: account.typeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(LucideIcons.landmark, color: account.typeColor, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(account.name, style: AppTextStyles.h3(color: fg)),
                          Text(account.typeLabel, style: AppTextStyles.caption(color: muted)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: border, height: 1),
                const SizedBox(height: 16),
                _InfoRow(label: 'เลขที่บัญชี', value: account.formattedNumber, canCopy: true, fg: fg, muted: muted),
                const SizedBox(height: 12),
                _InfoRow(label: 'ยอดเงินคงเหลือ', value: '฿${_fmt(account.balance)}', fg: fg, muted: muted),
                const SizedBox(height: 12),
                _InfoRow(label: 'สถานะบัญชี', value: account.isActive ? 'เปิดใช้งานปกติ (Active)' : 'ระงับชั่วคราว', fg: fg, muted: muted),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: BlocksButton(
                    label: 'ปิด',
                    onPressed: () => Navigator.of(ctx).pop(),
                    variant: BlocksButtonVariant.secondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _fmt(double v) {
    final p = v.toStringAsFixed(2).split('.');
    final n = p[0].replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '$n.${p[1]}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool canCopy;
  final Color fg;
  final Color muted;

  const _InfoRow({
    required this.label,
    required this.value,
    this.canCopy = false,
    required this.fg,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall(color: muted)),
        Row(
          children: [
            Text(
              value,
              style: AppTextStyles.label(color: fg).copyWith(fontWeight: FontWeight.w600),
            ),
            if (canCopy) ...[
              const SizedBox(width: 6),
              Icon(LucideIcons.copy, size: 14, color: AppColors.chartIndigo),
            ],
          ],
        ),
      ],
    );
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
  final AccountModel account;
  final VoidCallback onTap;

  const _AccountChip({required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppColors.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${account.name} ${account.maskedNumber}',
            style: AppTextStyles.caption(color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Icon(LucideIcons.lock, color: Colors.white70, size: 10),
        ],
      ),
    ),
  );
}
