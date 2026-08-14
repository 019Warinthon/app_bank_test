// lib/features/profile/widgets/biometric_auth_dialog.dart

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/security_service.dart';

enum BiometricType { faceId, fingerprint }

class BiometricAuthDialog extends StatefulWidget {
  final BiometricType type;
  final String title;
  final String subtitle;

  const BiometricAuthDialog({
    super.key,
    this.type = BiometricType.faceId,
    this.title = 'ยืนยันตัวตนด้วยชีวมาตร',
    this.subtitle = 'LuxBank ต้องการยืนยันตัวตนของคุณ',
  });

  static Future<bool> show(
    BuildContext context, {
    BiometricType? type,
    String? title,
    String? subtitle,
  }) async {
    final isFace = SecurityService.instance.useFaceId;
    final defaultType = type ?? (isFace ? BiometricType.faceId : BiometricType.fingerprint);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BiometricAuthDialog(
        type: defaultType,
        title: title ?? (defaultType == BiometricType.faceId ? 'Face ID สำหรับ LuxBank' : 'Touch ID สำหรับ LuxBank'),
        subtitle: subtitle ?? 'วางใบหน้าในกรอบหรือแตะเซ็นเซอร์เพื่อยืนยันตัวตน',
      ),
    );
    return result ?? false;
  }

  @override
  State<BiometricAuthDialog> createState() => _BiometricAuthDialogState();
}

class _BiometricAuthDialogState extends State<BiometricAuthDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _startSimulatedScan();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startSimulatedScan() async {
    // Simulate scan duration
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    setState(() {
      _isSuccess = true;
    });

    // Brief pause to show success animation
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final isFace = widget.type == BiometricType.faceId;

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bank Brand Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.chartIndigo,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  'LuxBank Security',
                  style: AppTextStyles.label(color: AppColors.chartIndigo).copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Scanning Animation Area
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Pulse Ring
                if (!_isSuccess)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = 1.0 + (_pulseController.value * 0.25);
                      final opacity = (1.0 - _pulseController.value).clamp(0.1, 0.6);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.chartIndigo.withValues(alpha: opacity),
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // Main Scanner Container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: _isSuccess
                        ? const Color(0xFF10B981)
                        : AppColors.chartIndigo.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (_isSuccess)
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                    ],
                  ),
                  child: Center(
                    child: _isSuccess
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 48)
                        : Icon(
                            isFace ? LucideIcons.scanFace : LucideIcons.fingerprint,
                            color: AppColors.chartIndigo,
                            size: 44,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title & Status
            Text(
              _isSuccess ? 'ยืนยันตัวตนสำเร็จ!' : widget.title,
              style: AppTextStyles.h3(color: _isSuccess ? const Color(0xFF10B981) : fg),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isSuccess ? 'ความถูกต้อง 100% · ปลอดภัย' : widget.subtitle,
              style: AppTextStyles.bodySmall(color: muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Cancel button
            if (!_isSuccess)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'ยกเลิก (ใช้รหัส PIN แทน)',
                    style: AppTextStyles.label(color: muted),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
