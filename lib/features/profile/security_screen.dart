import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'services/security_service.dart';
import 'widgets/biometric_auth_dialog.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _useFingerprint = true;
  bool _useFaceId = true;
  bool _useOtpForHighAmount = true;
  double _dailyLimit = 50000;

  // PIN Setup State
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _statusMessage = 'กรุณากำหนดรหัส PIN 6 หลักใหม่';

  void _onKeyPress(String value) {
    setState(() {
      if (!_isConfirming) {
        if (_pin.length < 6) {
          _pin += value;
          if (_pin.length == 6) {
            _isConfirming = true;
            _statusMessage = 'ยืนยันรหัส PIN 6 หลักอีกครั้ง';
          }
        }
      } else {
        if (_confirmPin.length < 6) {
          _confirmPin += value;
          if (_confirmPin.length == 6) {
            if (_pin == _confirmPin) {
              _showSuccessDialog();
            } else {
              _statusMessage = '❌ รหัส PIN ไม่ตรงกัน กรุณาลองใหม่';
              _pin = '';
              _confirmPin = '';
              _isConfirming = false;
            }
          }
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
          _statusMessage = 'กรุณากำหนดรหัส PIN 6 หลักใหม่';
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
        final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0x2210B981),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.checkCircle2, color: AppColors.success, size: 36),
              ),
              const SizedBox(height: 16),
              Text('ตั้งรหัส PIN สำเร็จ!', style: AppTextStyles.h4(color: fg)),
              const SizedBox(height: 8),
              Text(
                'รหัส PIN ใหม่ของคุณถูกบันทึกเรียบร้อยแล้ว ใช้สำหรับเข้าสู่ระบบและยืนยันการทำรายการ',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(color: muted),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: BlocksButton(
                  label: 'ตกลง',
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _pin = '';
                      _confirmPin = '';
                      _isConfirming = false;
                      _statusMessage = 'กรุณากำหนดรหัส PIN 6 หลักใหม่';
                    });
                  },
                  variant: BlocksButtonVariant.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _simulateBiometricAuth(String type) async {
    final isFace = type.contains('Face');
    final success = await BiometricAuthDialog.show(
      context,
      type: isFace ? BiometricType.faceId : BiometricType.fingerprint,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('สแกน $type สำเร็จเรียบร้อย!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    final currentPinLength = _isConfirming ? _confirmPin.length : _pin.length;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('รหัสผ่าน & ความปลอดภัย', style: AppTextStyles.h3(color: fg)),
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
            // ── PIN Setup Card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppColors.radiusXl),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.chartIndigo.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppColors.radiusMd),
                        ),
                        child: const Icon(LucideIcons.keyRound, color: AppColors.chartIndigo, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ตั้งค่ารหัส PIN 6 หลัก', style: AppTextStyles.label(color: fg)),
                            Text(_statusMessage, style: AppTextStyles.caption(color: muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // PIN Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (i) {
                      final isFilled = i < currentPinLength;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFilled
                              ? AppColors.chartIndigo
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Keypad Grid
                  _buildKeypad(fg, muted, cardBg, border),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Biometrics Options ──
            Text('การยืนยันตัวตนด้วยไบโอเมตริกซ์', style: AppTextStyles.label(color: fg)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppColors.radiusLg),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  _SecurityToggleTile(
                    icon: LucideIcons.fingerprint,
                    title: 'เปิดใช้ Touch ID / ลายนิ้วมือ',
                    subtitle: 'สแกนเพื่อเข้าสู่ระบบอย่างรวดเร็ว',
                    value: _useFingerprint,
                    onChanged: (v) {
                      setState(() => _useFingerprint = v);
                      SecurityService.instance.toggleBiometrics(v);
                    },
                    onTestTap: () => _simulateBiometricAuth('Touch ID'),
                    fg: fg,
                    muted: muted,
                    border: border,
                  ),
                  Divider(color: border, height: 1),
                  _SecurityToggleTile(
                    icon: LucideIcons.scanFace,
                    title: 'เปิดใช้ Face ID / สแกนใบหน้า',
                    subtitle: 'ยืนยันใบหน้าก่อนอนุมัติการโอนเงิน',
                    value: _useFaceId,
                    onChanged: (v) {
                      setState(() => _useFaceId = v);
                      SecurityService.instance.toggleFaceId(v);
                    },
                    onTestTap: () => _simulateBiometricAuth('Face ID'),
                    fg: fg,
                    muted: muted,
                    border: border,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Advanced Security ──
            Text('ระดับความปลอดภัยเพิ่มเติม', style: AppTextStyles.label(color: fg)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppColors.radiusLg),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.chartAmber.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(LucideIcons.shieldAlert, color: AppColors.chartAmber, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ยืนยัน OTP เมื่อโอนเกิน 50,000฿', style: AppTextStyles.label(color: fg)),
                            Text('เพิ่มความปลอดภัยเมื่อทำรายการยอดสูง', style: AppTextStyles.caption(color: muted)),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _useOtpForHighAmount,
                        onChanged: (v) => setState(() => _useOtpForHighAmount = v),
                        activeTrackColor: AppColors.chartIndigo,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: border, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('จำกัดวงเงินโอนสูงสุดต่อวัน', style: AppTextStyles.label(color: fg)),
                          Text('฿${_dailyLimit.toStringAsFixed(0)} / วัน', style: AppTextStyles.caption(color: AppColors.chartIndigo)),
                        ],
                      ),
                    ],
                  ),
                  Slider(
                    value: _dailyLimit,
                    min: 10000,
                    max: 500000,
                    divisions: 49,
                    activeColor: AppColors.chartIndigo,
                    onChanged: (val) => setState(() => _dailyLimit = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(Color fg, Color muted, Color cardBg, Color border) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['bio', '0', 'back'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key == 'bio') {
                return IconButton(
                  onPressed: () => _simulateBiometricAuth('Face ID / Touch ID'),
                  icon: const Icon(LucideIcons.fingerprint, color: AppColors.chartIndigo, size: 24),
                );
              }
              if (key == 'back') {
                return IconButton(
                  onPressed: _onBackspace,
                  icon: Icon(Icons.backspace_outlined, color: fg, size: 22),
                );
              }
              return InkWell(
                onTap: () => _onKeyPress(key),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: border),
                  ),
                  child: Text(
                    key,
                    style: AppTextStyles.h3(color: fg),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _SecurityToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTestTap;
  final Color fg;
  final Color muted;
  final Color border;

  const _SecurityToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.onTestTap,
    required this.fg,
    required this.muted,
    required this.border,
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
          IconButton(
            onPressed: onTestTap,
            icon: const Icon(LucideIcons.scan, size: 18, color: AppColors.chartIndigo),
            tooltip: 'ทดสอบการสแกน',
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
