import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometrics = true;
  bool _notifications = true;
  bool _faceId = true;
  bool _darkMode = true;

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
        title: Text('ตั้งค่าระบบ', style: AppTextStyles.h3(color: fg)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_rounded, color: fg, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ความปลอดภัย', style: AppTextStyles.label(color: fg)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppColors.radiusLg),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  _SettingToggle(
                    icon: LucideIcons.fingerprint,
                    title: 'เข้าสู่ระบบด้วยลายนิ้วมือ',
                    subtitle: 'ใช้ Touch ID / Fingerprint',
                    value: _biometrics,
                    onChanged: (v) => setState(() => _biometrics = v),
                    fg: fg,
                    muted: muted,
                  ),
                  Divider(color: border, height: 1),
                  _SettingToggle(
                    icon: LucideIcons.scanFace,
                    title: 'เข้าสู่ระบบด้วย Face ID',
                    subtitle: 'สแกนใบหน้าก่อนทำรายการ',
                    value: _faceId,
                    onChanged: (v) => setState(() => _faceId = v),
                    fg: fg,
                    muted: muted,
                  ),
                  Divider(color: border, height: 1),
                  ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.chartIndigo.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.lock, color: AppColors.chartIndigo, size: 18),
                    ),
                    title: Text('เปลี่ยนรหัส PIN 6 หลัก', style: AppTextStyles.label(color: fg)),
                    trailing: const Icon(LucideIcons.chevronRight, size: 18),
                    onTap: () {
                      DialogPasswordConfirm.show(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('การแจ้งเตือน & การแสดงผล', style: AppTextStyles.label(color: fg)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppColors.radiusLg),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  _SettingToggle(
                    icon: LucideIcons.bell,
                    title: 'การแจ้งเตือนทำรายการ',
                    subtitle: 'แจ้งเตือนทันทีเมื่อมีเงินเข้า/ออก',
                    value: _notifications,
                    onChanged: (v) => setState(() => _notifications = v),
                    fg: fg,
                    muted: muted,
                  ),
                  Divider(color: border, height: 1),
                  _SettingToggle(
                    icon: LucideIcons.moon,
                    title: 'โหมดมืด (Dark Mode)',
                    subtitle: 'ใช้งานธีมมืดเพื่อถนอมสายตา',
                    value: _darkMode,
                    onChanged: (v) => setState(() => _darkMode = v),
                    fg: fg,
                    muted: muted,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('เกี่ยวกับแอปพลิเคชัน', style: AppTextStyles.label(color: fg)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppColors.radiusLg),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(LucideIcons.info, size: 18),
                    title: Text('เวอร์ชันแอปพลิเคชัน', style: AppTextStyles.label(color: fg)),
                    trailing: Text('v1.0.0 (build 102)', style: AppTextStyles.caption(color: muted)),
                  ),
                  Divider(color: border, height: 1),
                  ListTile(
                    leading: const Icon(LucideIcons.fileText, size: 18),
                    title: Text('ข้อกำหนดและเงื่อนไขการใช้งาน', style: AppTextStyles.label(color: fg)),
                    trailing: const Icon(LucideIcons.chevronRight, size: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: BlocksButton(
                label: 'ออกจากระบบ',
                onPressed: () {
                  DialogConfirmation.show(context);
                },
                variant: BlocksButtonVariant.destructive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color fg;
  final Color muted;

  const _SettingToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.fg,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.chartIndigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.chartIndigo, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label(color: fg)),
                Text(subtitle, style: AppTextStyles.caption(color: muted)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.chartIndigo,
          ),
        ],
      ),
    );
  }
}
