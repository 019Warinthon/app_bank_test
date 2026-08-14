import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/card_model.dart';

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

    final currentCardData = MockData.cards[_currentCard];

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
                itemCount: MockData.cards.length,
                onPageChanged: (i) => setState(() => _currentCard = i),
                itemBuilder: (context, index) {
                  final card = MockData.cards[index];
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
              children: List.generate(MockData.cards.length, (i) {
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
                  ),
                  const SizedBox(width: 10),
                  _CardAction(
                    icon: LucideIcons.settings,
                    label: 'ตั้งค่า',
                    color: AppColors.chartIndigo,
                    cardBg: cardBg,
                    border: border,
                    muted: muted,
                  ),
                  const SizedBox(width: 10),
                  _CardAction(
                    icon: LucideIcons.eye,
                    label: 'ดูรายละเอียด',
                    color: AppColors.chartCyan,
                    cardBg: cardBg,
                    border: border,
                    muted: muted,
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
}

class _CreditCardWidget extends StatelessWidget {
  final CardModel card;
  const _CreditCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    final isVisa = card.type == CardType.visa;
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

  const _CardAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.cardBg,
    required this.border,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
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
