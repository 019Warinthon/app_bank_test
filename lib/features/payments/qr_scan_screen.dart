import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_tabIndex == 0 ? 'สแกนจ่าย PromptPay' : 'QR Code ของฉัน', style: AppTextStyles.h3(color: fg)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_rounded, color: fg, size: 20),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // Tab Toggle
          Container(
            width: 260,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(AppColors.radiusFull),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _tabIndex == 0 ? cardBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppColors.radiusFull),
                      ),
                      child: Text(
                        'สแกน QR',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.label(color: _tabIndex == 0 ? fg : muted),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _tabIndex == 1 ? cardBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppColors.radiusFull),
                      ),
                      child: Text(
                        'QR ของฉัน',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.label(color: _tabIndex == 1 ? fg : muted),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _tabIndex == 0 ? _buildScanner(fg, muted) : _buildMyQr(fg, muted, cardBg),
          ),
        ],
      ),
    );
  }

  Widget _buildScanner(Color fg, Color muted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Viewfinder frame
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.chartIndigo, width: 2.5),
              ),
            ),
            // Animated Scan Line
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Positioned(
                  top: 20 + (_animController.value * 220),
                  child: Container(
                    width: 220,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.chartIndigo,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.chartIndigo.withValues(alpha: 0.8),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Icon(LucideIcons.scan, size: 80, color: Colors.white24),
          ],
        ),
        const SizedBox(height: 28),
        Text('วาง QR Code ให้อยู่ในกรอบเพื่อสแกน', style: AppTextStyles.body(color: fg)),
        const SizedBox(height: 6),
        Text('รองรับ PromptPay, Thai QR Payment, Slip QR', style: AppTextStyles.caption(color: muted)),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CircleActionButton(icon: LucideIcons.image, label: 'เลือกรูป', onTap: () {}),
            const SizedBox(width: 24),
            _CircleActionButton(icon: LucideIcons.zap, label: 'แฟลช', onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildMyQr(Color fg, Color muted, Color cardBg) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppColors.radiusXl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.chartIndigo,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text('LuxBank PromptPay', style: AppTextStyles.label(color: fg).copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 20),
              // QR Code Graphic Mockup
              Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(LucideIcons.qrCode, size: 170, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Text('Warinthon K.', style: AppTextStyles.label(color: fg)),
              Text('PromptPay: 098-765-4321', style: AppTextStyles.bodySmall(color: muted)),
              const SizedBox(height: 20),
              BlocksButton(
                label: 'บันทึก QR Code',
                onPressed: () {},
                variant: BlocksButtonVariant.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: border),
            ),
            child: Icon(icon, color: AppColors.chartIndigo, size: 20),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption(color: muted)),
        ],
      ),
    );
  }
}
