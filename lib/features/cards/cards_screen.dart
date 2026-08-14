import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../profile/widgets/pin_auth_sheet.dart';
import 'models/card_model.dart';
import 'services/card_service.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  int _currentCard = 0;
  final _pageController = PageController(viewportFraction: 0.88);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted =
        isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;

    final cards = CardService.instance.getAll();
    final currentCardData = cards[_currentCard.clamp(0, cards.length - 1)];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('บัตรของฉัน', style: AppTextStyles.h3(color: fg)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(LucideIcons.plus, color: fg, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // ── Card Carousel ──
            SizedBox(
              height: 210,
              child: PageView.builder(
                controller: _pageController,
                itemCount: cards.length,
                onPageChanged: (i) => setState(() => _currentCard = i),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _CreditCardWidget(card: card),
                  );
                },
              ),
            ),

            // Page indicator
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cards.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentCard == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentCard == i
                        ? AppColors.chartIndigo
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            // ── Card Actions ──
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _CardAction(
                    icon: currentCardData.isLocked
                        ? LucideIcons.unlock
                        : LucideIcons.lock,
                    label: currentCardData.isLocked ? 'ปลดล็อค' : 'ล็อคบัตร',
                    color: AppColors.chartAmber,
                    cardBg: cardBg,
                    border: border,
                    muted: muted,
                    onTap: () async {
                      final authenticated = await PinAuthSheet.show(
                        context,
                        title: currentCardData.isLocked ? 'ยืนยันเพื่อปลดล็อคบัตร' : 'ยืนยันเพื่อล็อคบัตร',
                        subtitle: 'กรุณากรอกรหัส PIN หรือสแกนเพื่อเปลี่ยนสถานะความปลอดภัยของบัตร',
                      );
                      if (authenticated) {
                        await CardService.instance.toggleLock(currentCardData.id);
                        setState(() {});
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(currentCardData.isLocked ? 'ล็อคบัตรเรียบร้อยแล้ว' : 'ปลดล็อคบัตรเรียบร้อยแล้ว')),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  _CardAction(
                    icon: LucideIcons.settings,
                    label: 'ตั้งค่า',
                    color: AppColors.chartIndigo,
                    cardBg: cardBg,
                    border: border,
                    muted: muted,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กำลังเปิดเมนูตั้งค่าบัตร')),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  _CardAction(
                    icon: LucideIcons.eye,
                    label: 'ดูรายละเอียด',
                    color: AppColors.chartCyan,
                    cardBg: cardBg,
                    border: border,
                    muted: muted,
                    onTap: () async {
                      final authenticated = await PinAuthSheet.show(
                        context,
                        title: 'ยืนยันตัวตนเพื่อดูข้อมูลบัตร',
                        subtitle: 'กรุณากรอกรหัส PIN หรือสแกนเพื่อดูหมายเลขบัตรเต็มและรหัส CVV',
                      );
                      if (authenticated && context.mounted) {
                        _showCardDetailsModal(context, currentCardData);
                      }
                    },
                  ),
                ],
              ),
            ),

            // ── Spending Limit ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocksCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('วงเงินใช้จ่าย', style: AppTextStyles.label(color: fg)),
                    const SizedBox(height: 4),
                    Text(
                      '฿${currentCardData.currentSpending.toStringAsFixed(0)} / ฿${currentCardData.spendingLimit.toStringAsFixed(0)}',
                      style: AppTextStyles.bodySmall(color: muted),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: currentCardData.spendingPercentage,
                        minHeight: 8,
                        backgroundColor: isDark
                            ? AppColors.secondaryDark
                            : AppColors.secondaryLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          currentCardData.spendingPercentage > 0.8
                              ? AppColors.destructiveLight
                              : AppColors.chartIndigo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'เหลืออีก ฿${(currentCardData.spendingLimit - currentCardData.currentSpending).toStringAsFixed(0)}',
                      style: AppTextStyles.caption(color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ),

            // ── Stats ──
            const Padding(
              padding: EdgeInsets.all(20),
              child: StatsProgress(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetailsModal(BuildContext context, CardModel card) {
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
                        gradient: LinearGradient(colors: card.gradientColors),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(LucideIcons.creditCard, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ข้อมูลบัตร ${card.tierLabel} ${card.networkLabel}', style: AppTextStyles.h4(color: fg)),
                          Text('ปลดล็อคข้อมูลความปลอดภัยเรียบร้อยแล้ว', style: AppTextStyles.caption(color: AppColors.success)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: border, height: 1),
                const SizedBox(height: 16),
                _InfoCardRow(label: 'หมายเลขบัตร', value: card.cardNumber, canCopy: true, fg: fg, muted: muted),
                const SizedBox(height: 12),
                _InfoCardRow(label: 'ชื่อผู้ถือบัตร', value: card.holderName, fg: fg, muted: muted),
                const SizedBox(height: 12),
                _InfoCardRow(label: 'วันหมดอายุ (EXP)', value: card.expiryDate, fg: fg, muted: muted),
                const SizedBox(height: 12),
                _InfoCardRow(label: 'รหัสความปลอดภัย (CVV)', value: card.cvv, isSecret: true, fg: fg, muted: muted),
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
}

class _InfoCardRow extends StatelessWidget {
  final String label;
  final String value;
  final bool canCopy;
  final bool isSecret;
  final Color fg;
  final Color muted;

  const _InfoCardRow({
    required this.label,
    required this.value,
    this.canCopy = false,
    this.isSecret = false,
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
              style: AppTextStyles.label(color: isSecret ? AppColors.destructiveLight : fg)
                  .copyWith(fontWeight: FontWeight.w700, letterSpacing: isSecret ? 2 : 1),
            ),
            if (canCopy) ...[
              const SizedBox(width: 8),
              Icon(LucideIcons.copy, size: 14, color: AppColors.chartIndigo),
            ],
          ],
        ),
      ],
    );
  }
}

class _CreditCardWidget extends StatelessWidget {
  final CardModel card;
  const _CreditCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    final isVisa = card.network == CardNetwork.visa;
    final colors = card.tier == CardTier.platinum
        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E), const Color(0xFF0F3460)]
        : [const Color(0xFFD4AF37), const Color(0xFFC5961E), const Color(0xFFB8860B)];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LuxBank',
                style: AppTextStyles.label(color: Colors.white).copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              Text(
                card.tier == CardTier.platinum ? 'PLATINUM' : 'GOLD',
                style: AppTextStyles.caption(
                  color: Colors.white.withValues(alpha: 0.7),
                ).copyWith(letterSpacing: 3),
              ),
            ],
          ),
          // Chip icon
          Container(
            width: 40,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade300,
                  Colors.amber.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Text(
            card.maskedNumber,
            style: AppTextStyles.h3(color: Colors.white).copyWith(
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: AppTextStyles.caption(
                      color: Colors.white.withValues(alpha: 0.5),
                    ).copyWith(fontSize: 9, letterSpacing: 1),
                  ),
                  Text(
                    card.holderName,
                    style: AppTextStyles.bodySmall(color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EXPIRES',
                    style: AppTextStyles.caption(
                      color: Colors.white.withValues(alpha: 0.5),
                    ).copyWith(fontSize: 9, letterSpacing: 1),
                  ),
                  Text(
                    card.expiryDate,
                    style: AppTextStyles.bodySmall(color: Colors.white),
                  ),
                ],
              ),
              Text(
                isVisa ? 'VISA' : 'MC',
                style: AppTextStyles.h3(
                  color: Colors.white.withValues(alpha: 0.8),
                ).copyWith(
                  fontWeight: FontWeight.w800,
                  fontStyle: isVisa ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color cardBg;
  final Color border;
  final Color muted;
  final VoidCallback? onTap;

  const _CardAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.cardBg,
    required this.border,
    required this.muted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppColors.radiusLg),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(label, style: AppTextStyles.caption(color: muted)),
            ],
          ),
        ),
      ),
    );
  }
}
