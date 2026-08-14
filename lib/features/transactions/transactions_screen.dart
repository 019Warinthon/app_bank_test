// lib/features/transactions/transactions_screen.dart
// Screen: full transaction list with search + tab filter.
// Uses: TransactionService (data) + TransactionTile (shared widget)

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/widgets/app_empty_state.dart';
import 'models/transaction_model.dart';
import 'services/transaction_service.dart';
import 'widgets/transaction_tile.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _txService = TransactionService.instance;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TransactionModel> get _filtered {
    TransactionType? type = switch (_tabController.index) {
      1 => TransactionType.income,
      2 => TransactionType.expense,
      _ => null,
    };
    return _txService.filter(type: type, query: _searchQuery);
  }

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
        title: Text('รายการทั้งหมด', style: AppTextStyles.h3(color: fg)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(LucideIcons.download, color: fg, size: 20),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocksInput(
              hint: 'ค้นหารายการ...',
              leading: const Icon(LucideIcons.search, size: 16),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          const SizedBox(height: 12),

          // ── Tab bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
                borderRadius: BorderRadius.circular(AppColors.radiusMd),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (_) => setState(() {}),
                indicator: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(AppColors.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: fg,
                unselectedLabelColor: muted,
                labelStyle: AppTextStyles.label(color: fg),
                tabs: const [
                  Tab(text: 'ทั้งหมด'),
                  Tab(text: 'รายรับ'),
                  Tab(text: 'รายจ่าย'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── List ──
          Expanded(
            child: _filtered.isEmpty
                ? AppEmptyState(
                    icon: LucideIcons.searchX,
                    title: 'ไม่พบรายการ',
                    subtitle: 'ลองเปลี่ยนคำค้นหาหรือตัวกรอง',
                    actionLabel: 'ล้างการค้นหา',
                    onAction: () => setState(() => _searchQuery = ''),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final tx = _filtered[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(AppColors.radiusLg),
                          border: Border.all(color: border),
                        ),
                        child: TransactionTile(tx: tx),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
