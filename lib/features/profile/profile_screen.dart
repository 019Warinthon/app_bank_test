import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Profile screen using lux_blocks FormSideLabels block
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('โปรไฟล์', style: AppTextStyles.h3(color: fg)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: Icon(LucideIcons.settings, color: fg, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar Section ──
            Center(
              child: Column(
                children: [
                  const BlocksAvatar(
                    name: 'Warinthon K.',
                    size: BlocksAvatarSize.xl,
                  ),
                  const SizedBox(height: 12),
                  Text('Warinthon K.', style: AppTextStyles.h3(color: fg)),
                  Text(
                    'warinthon@luxbank.com',
                    style: AppTextStyles.bodySmall(color: muted),
                  ),
                  const SizedBox(height: 8),
                  const BlocksBadge(
                    label: 'Platinum Member',
                    variant: BlocksBadgeVariant.info,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Quick Stats ──
            Row(
              children: [
                _StatBox(value: '฿328K', label: 'ยอดคงเหลือ', color: AppColors.chartIndigo, fg: fg, cardBg: cardBg, border: border),
                const SizedBox(width: 10),
                _StatBox(value: '10', label: 'รายการ', color: AppColors.chartGreen, fg: fg, cardBg: cardBg, border: border),
                const SizedBox(width: 10),
                _StatBox(value: '2', label: 'บัตร', color: AppColors.chartAmber, fg: fg, cardBg: cardBg, border: border),
              ],
            ),

            const SizedBox(height: 24),

            // ── Menu Items ──
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppColors.radiusLg),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: LucideIcons.user,
                    label: 'แก้ไขโปรไฟล์',
                    subtitle: 'ชื่อ, อีเมล, ชีวประวัติ',
                    iconBg: AppColors.chartIndigo,
                    onTap: () => _showEditProfileSheet(context),
                  ),
                  Divider(color: border, height: 1),
                  _ProfileMenuItem(
                    icon: LucideIcons.shieldCheck,
                    label: 'รหัสผ่าน & ความปลอดภัย',
                    subtitle: 'PIN, Face ID, ลายนิ้วมือ',
                    iconBg: AppColors.chartPurple,
                    onTap: () => context.push('/security'),
                  ),
                  Divider(color: border, height: 1),
                  _ProfileMenuItem(
                    icon: LucideIcons.creditCard,
                    label: 'บัตรและบัญชีของฉัน',
                    subtitle: 'จัดการบัตรเดบิต/เครดิต',
                    iconBg: AppColors.chartCyan,
                    onTap: () => context.go('/cards'),
                  ),
                  Divider(color: border, height: 1),
                  _ProfileMenuItem(
                    icon: LucideIcons.bell,
                    label: 'การแจ้งเตือน',
                    subtitle: 'ตั้งค่าการแจ้งเตือนรายการ',
                    iconBg: AppColors.chartAmber,
                    onTap: () => context.push('/notifications'),
                  ),
                  Divider(color: border, height: 1),
                  _ProfileMenuItem(
                    icon: LucideIcons.settings,
                    label: 'ตั้งค่าแอปพลิเคชัน',
                    subtitle: 'ธีม, ภาษา, การแสดงผล',
                    iconBg: AppColors.chartNeutral,
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Logout Button ──
            SizedBox(
              width: double.infinity,
              child: BlocksButton(
                label: 'ออกจากระบบ',
                onPressed: () => _showLogoutDialog(context),
                variant: BlocksButtonVariant.destructive,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'v1.0.0 (build 102) · LuxBank',
              style: AppTextStyles.caption(color: muted).copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, ctrl) => Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: ctrl,
                    child: const FormSideLabels(useScaffold: false),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
        final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('ออกจากระบบ?', style: AppTextStyles.h4(color: fg)),
          content: Text(
            'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?',
            style: AppTextStyles.body(color: muted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('ยกเลิก', style: AppTextStyles.label(color: AppColors.chartIndigo)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/login');
              },
              child: Text('ออกจากระบบ', style: AppTextStyles.label(color: AppColors.destructiveLight)),
            ),
          ],
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color fg;
  final Color cardBg;
  final Color border;

  const _StatBox({
    required this.value,
    required this.label,
    required this.color,
    required this.fg,
    required this.cardBg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.h4(color: color).copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption(color: fg).copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconBg;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconBg.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconBg, size: 18),
      ),
      title: Text(label, style: AppTextStyles.label(color: fg)),
      subtitle: Text(subtitle, style: AppTextStyles.caption(color: muted)),
      trailing: Icon(LucideIcons.chevronRight, size: 16, color: muted),
    );
  }
}
