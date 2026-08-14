// lib/data/mock/mock_transactions.dart
// Mock data: transaction history + analytics helpers.

import '../models/models.dart';

abstract final class MockTransactions {
  static final all = [
    TransactionModel(
      id: 'tx-001',
      title: 'เงินเดือน',
      description: 'บริษัท LuxTech Co., Ltd.',
      amount: 85_000.00,
      type: TransactionType.income,
      category: TransactionCategory.salary,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      accountId: 'acc-001',
      referenceId: 'REF20260814001',
    ),
    TransactionModel(
      id: 'tx-002',
      title: 'Grab Food',
      description: 'อาหารกลางวัน',
      amount: 245.00,
      type: TransactionType.expense,
      category: TransactionCategory.food,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-003',
      title: 'BTS Rabbit',
      description: 'เติมเงิน Rabbit Card',
      amount: 500.00,
      type: TransactionType.expense,
      category: TransactionCategory.transport,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 1)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-004',
      title: 'โอนเงิน',
      description: 'ส่งให้คุณแม่',
      amount: 10_000.00,
      type: TransactionType.transfer,
      category: TransactionCategory.transfer,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      recipientName: 'สมศรี ก.',
      recipientBank: 'กสิกรไทย',
      accountId: 'acc-001',
      referenceId: 'REF20260813001',
    ),
    TransactionModel(
      id: 'tx-005',
      title: 'Central Online',
      description: 'เสื้อผ้า',
      amount: 2_890.00,
      type: TransactionType.expense,
      category: TransactionCategory.shopping,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 2)),
      accountId: 'acc-002',
    ),
    TransactionModel(
      id: 'tx-006',
      title: 'ค่าไฟฟ้า MEA',
      description: 'การไฟฟ้านครหลวง',
      amount: 1_850.00,
      type: TransactionType.expense,
      category: TransactionCategory.bills,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 3)),
      accountId: 'acc-002',
    ),
    TransactionModel(
      id: 'tx-007',
      title: 'Netflix',
      description: 'Premium Plan',
      amount: 419.00,
      type: TransactionType.expense,
      category: TransactionCategory.entertainment,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 4)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-008',
      title: 'เงินปันผล',
      description: 'กองทุน LTF',
      amount: 3_200.00,
      type: TransactionType.income,
      category: TransactionCategory.investment,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 5)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-009',
      title: 'โรงพยาบาล',
      description: 'ตรวจสุขภาพประจำปี',
      amount: 4_500.00,
      type: TransactionType.expense,
      category: TransactionCategory.health,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 6)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-010',
      title: 'Udemy Course',
      description: 'Flutter Masterclass',
      amount: 390.00,
      type: TransactionType.expense,
      category: TransactionCategory.education,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 7)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-011',
      title: 'Figma Freelance',
      description: 'งานออกแบบ UI/UX',
      amount: 15_000.00,
      type: TransactionType.income,
      category: TransactionCategory.freelance,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 8)),
      accountId: 'acc-001',
      referenceId: 'REF20260806001',
    ),
    TransactionModel(
      id: 'tx-012',
      title: 'ท็อปอัพเกม',
      description: 'ROV Diamond',
      amount: 790.00,
      type: TransactionType.expense,
      category: TransactionCategory.topUp,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 9)),
      accountId: 'acc-001',
    ),
  ];

  // ── Filtered Getters ─────────────────────────────────

  static List<TransactionModel> get income =>
      all.where((t) => t.isIncome).toList();

  static List<TransactionModel> get expenses =>
      all.where((t) => t.isExpense).toList();

  static List<TransactionModel> get transfers =>
      all.where((t) => t.isTransfer).toList();

  static List<TransactionModel> get pending =>
      all.where((t) => t.isPending).toList();

  /// Recent N transactions
  static List<TransactionModel> recent([int count = 5]) =>
      all.take(count).toList();

  /// Filter by account
  static List<TransactionModel> byAccount(String accountId) =>
      all.where((t) => t.accountId == accountId).toList();

  /// Filter by category
  static List<TransactionModel> byCategory(TransactionCategory cat) =>
      all.where((t) => t.category == cat).toList();

  // ── Analytics ────────────────────────────────────────

  static double get totalIncome =>
      income.fold(0, (s, t) => s + t.amount);

  static double get totalExpenses =>
      expenses.fold(0, (s, t) => s + t.amount);

  static double get netBalance => totalIncome - totalExpenses;

  /// Spending grouped by category → { category: totalAmount }
  static Map<TransactionCategory, double> get spendingByCategory {
    final Map<TransactionCategory, double> result = {};
    for (final t in expenses) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  // ── Static Analytics Data ─────────────────────────────

  /// Monthly income vs expense for the past 6 months
  static const monthlyData = [
    {'month': 'ม.ค.', 'income': 85_000.0, 'expense': 42_000.0},
    {'month': 'ก.พ.', 'income': 85_000.0, 'expense': 38_500.0},
    {'month': 'มี.ค.', 'income': 88_200.0, 'expense': 45_200.0},
    {'month': 'เม.ย.', 'income': 85_000.0, 'expense': 51_000.0},
    {'month': 'พ.ค.', 'income': 92_000.0, 'expense': 39_800.0},
    {'month': 'มิ.ย.', 'income': 85_000.0, 'expense': 34_500.0},
  ];

  /// Spending breakdown by category (current month)
  static const categoryBreakdown = [
    {'category': 'อาหาร',    'amount': 8_500.0,  'percentage': 0.25},
    {'category': 'เดินทาง',  'amount': 4_200.0,  'percentage': 0.12},
    {'category': 'ช้อปปิ้ง', 'amount': 6_800.0,  'percentage': 0.20},
    {'category': 'ค่าบิล',   'amount': 5_200.0,  'percentage': 0.15},
    {'category': 'บันเทิง',  'amount': 3_100.0,  'percentage': 0.09},
    {'category': 'สุขภาพ',   'amount': 4_500.0,  'percentage': 0.13},
    {'category': 'อื่นๆ',    'amount': 2_200.0,  'percentage': 0.06},
  ];
}
