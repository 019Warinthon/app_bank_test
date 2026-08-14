import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../profile/widgets/pin_auth_sheet.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final muted =
        isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;

    final actions = [
      _QuickAction('โอนเงิน', LucideIcons.arrowUpRight, const Color(0xFF6366F1), '/transfer'),
      _QuickAction('ชำระบิล', LucideIcons.receipt, const Color(0xFF06B6D4), '/pay-bills'),
      _QuickAction('เติมเงิน', LucideIcons.smartphone, const Color(0xFF22C55E), '/pay-bills'),
      _QuickAction('สแกน QR', LucideIcons.scanLine, const Color(0xFFF59E0B), '/qr-scan'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('บริการด่วน', style: AppTextStyles.h4(color: fg)),
        const SizedBox(height: 12),
        Row(
          children: actions.map((action) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action != actions.last ? 10 : 0,
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (action.route == '/transfer') {
                      final authenticated = await PinAuthSheet.show(
                        context,
                        title: 'ยืนยันรหัสความปลอดภัย',
                        subtitle: 'กรุณากรอกรหัส PIN หรือสแกนลายนิ้วมือเพื่อเข้าสู่ระบบโอนเงิน',
                      );
                      if (authenticated && context.mounted) {
                        context.push(action.route);
                      }
                    } else {
                      context.push(action.route);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(AppColors.radiusLg),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: action.color.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppColors.radiusMd),
                          ),
                          child: Icon(
                            action.icon,
                            color: action.color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          action.label,
                          style: AppTextStyles.caption(color: muted),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _QuickAction(this.label, this.icon, this.color, this.route);
}
