import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
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

  List<TransactionModel> get _filteredTransactions {
    var list = MockData.transactions;
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (t.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false))
          .toList();
    }
    switch (_tabController.index) {
      case 1:
        return list.where((t) => t.type == TransactionType.income).toList();
      case 2:
        return list.where((t) => t.type == TransactionType.expense).toList();
      default:
        return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted =
        isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
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

          // ── Tabs ──
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

          // ── Transaction List ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final tx = _filteredTransactions[index];
                final isIncome = tx.isIncome;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(AppColors.radiusLg),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (isIncome
                                  ? AppColors.success
                                  : AppColors.destructiveLight)
                              .withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppColors.radiusMd),
                        ),
                        child: Icon(
                          isIncome
                              ? LucideIcons.arrowDownLeft
                              : LucideIcons.arrowUpRight,
                          color: isIncome
                              ? AppColors.success
                              : AppColors.destructiveLight,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.title,
                                style: AppTextStyles.label(color: fg)),
                            if (tx.description != null)
                              Text(tx.description!,
                                  style: AppTextStyles.caption(color: muted)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            tx.formattedAmount,
                            style: AppTextStyles.label(
                              color: isIncome
                                  ? AppColors.success
                                  : AppColors.destructiveLight,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            _formatDate(tx.date),
                            style: AppTextStyles.caption(color: muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inHours < 1) return '${diff.inMinutes} นาทีก่อน';
    if (diff.inHours < 24) return '${diff.inHours} ชม. ก่อน';
    if (diff.inDays == 1) return 'เมื่อวาน';
    if (diff.inDays < 7) return '${diff.inDays} วันก่อน';
    return '${date.day}/${date.month}/${date.year}';
  }
}
