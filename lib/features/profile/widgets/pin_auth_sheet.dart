// lib/features/profile/widgets/pin_auth_sheet.dart

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/security_service.dart';

class PinAuthSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSuccess;

  const PinAuthSheet({
    super.key,
    this.title = 'ยืนยันรหัส PIN',
    this.subtitle = 'กรุณากรอกรหัส PIN 6 หลักเพื่อเข้าใช้งานการโอนเงิน',
    required this.onSuccess,
  });

  static Future<bool> show(
    BuildContext context, {
    String title = 'ยืนยันรหัส PIN',
    String subtitle = 'กรุณากรอกรหัส PIN 6 หลักเพื่อเข้าใช้งานการโอนเงิน',
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PinAuthSheet(
        title: title,
        subtitle: subtitle,
        onSuccess: () => Navigator.of(ctx).pop(true),
      ),
    );
    return result ?? false;
  }

  @override
  State<PinAuthSheet> createState() => _PinAuthSheetState();
}

class _PinAuthSheetState extends State<PinAuthSheet>
    with SingleTickerProviderStateMixin {
  String _enteredPin = '';
  String _errorMessage = '';
  int _failedAttempts = 0;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Prompt biometrics automatically if enabled
    if (SecurityService.instance.isBiometricsEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerBiometricAuth();
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String num) {
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += num;
        _errorMessage = '';
      });

      if (_enteredPin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = '';
      });
    }
  }

  void _verifyPin() {
    final isValid = SecurityService.instance.verifyPin(_enteredPin);
    if (isValid) {
      widget.onSuccess();
    } else {
      _shakeController.forward(from: 0.0);
      setState(() {
        _failedAttempts++;
        _enteredPin = '';
        _errorMessage = 'รหัส PIN ไม่ถูกต้อง (ผิดครั้งที่ $_failedAttempts/3)';
      });
    }
  }

  Future<void> _triggerBiometricAuth() async {
    final success = await SecurityService.instance.authenticateWithBiometrics();
    if (!mounted) return;

    if (success) {
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForegroundLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
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

            // Icon Lock Badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.chartIndigo.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.shieldCheck,
                color: AppColors.chartIndigo,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),

            // Title & Subtitle
            Text(widget.title, style: AppTextStyles.h3(color: fg)),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: AppTextStyles.bodySmall(color: muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 6 PIN Dots with Shake
            AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                final offset = (_shakeController.value * 6 * 3.14159);
                return Transform.translate(
                  offset: Offset(
                    _shakeController.isAnimating
                        ? (10 *
                              (1 - _shakeController.value) *
                              (offset % 2 == 0 ? 1 : -1))
                        : 0,
                    0,
                  ),
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  final isFilled = i < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isFilled
                          ? AppColors.chartIndigo
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isFilled
                            ? AppColors.chartIndigo
                            : (isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
            ),

            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage,
                style: AppTextStyles.caption(
                  color: AppColors.destructiveLight,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ],

            const SizedBox(height: 24),

            // Keypad
            _buildKeypad(fg, muted),
            const SizedBox(height: 12),

            // Forgot PIN
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('กรุณาติดต่อสาขาธนาคารเพื่อรีเซ็ตรหัส PIN'),
                  ),
                );
              },
              child: Text(
                'ลืมรหัส PIN?',
                style: AppTextStyles.bodySmall(color: AppColors.chartIndigo),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(Color fg, Color muted) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3']
              .map(
                (n) =>
                    _KeypadButton(label: n, onTap: () => _onNumberPressed(n)),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6']
              .map(
                (n) =>
                    _KeypadButton(label: n, onTap: () => _onNumberPressed(n)),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9']
              .map(
                (n) =>
                    _KeypadButton(label: n, onTap: () => _onNumberPressed(n)),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Biometric button (Face ID / Fingerprint)
            _KeypadActionButton(
              icon: SecurityService.instance.useFaceId
                  ? LucideIcons.scanFace
                  : LucideIcons.fingerprint,
              onTap: _triggerBiometricAuth,
              color: AppColors.chartIndigo,
            ),
            _KeypadButton(label: '0', onTap: () => _onNumberPressed('0')),
            // Backspace
            _KeypadActionButton(
              icon: LucideIcons.delete,
              onTap: _onBackspace,
              color: muted,
            ),
          ],
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeypadButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final btnBg = isDark ? AppColors.secondaryDark : AppColors.secondaryLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 64,
          decoration: BoxDecoration(
            color: btnBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.h2(
              color: fg,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _KeypadActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _KeypadActionButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 72,
          height: 64,
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 28),
        ),
      ),
    );
  }
}
