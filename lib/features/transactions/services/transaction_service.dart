// lib/features/transactions/services/transaction_service.dart

import 'package:flutter/material.dart' show DateTimeRange;
import '../models/transaction_model.dart';

class TransactionService {
  TransactionService._();
  static final TransactionService instance = TransactionService._();

  final List<TransactionModel> _txs = [
    TransactionModel(
      id: 'tx-001', title: 'เงินเดือน',
      description: 'บริษัท LuxTech Co., Ltd.',
      amount: 85_000.00, type: TransactionType.income,
      category: TransactionCategory.salary,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      accountId: 'acc-001', referenceId: 'REF20260814001',
    ),
    TransactionModel(
      id: 'tx-002', title: 'Grab Food',
      description: 'อาหารกลางวัน',
      amount: 245.00, type: TransactionType.expense,
      category: TransactionCategory.food,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-003', title: 'BTS Rabbit',
      description: 'เติมเงิน Rabbit Card',
      amount: 500.00, type: TransactionType.expense,
      category: TransactionCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 1)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-004', title: 'โอนเงิน',
      description: 'ส่งให้คุณแม่',
      amount: 10_000.00, type: TransactionType.transfer,
      category: TransactionCategory.transfer,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      recipientName: 'สมศรี ก.', recipientBank: 'กสิกรไทย',
      accountId: 'acc-001', referenceId: 'REF20260813001',
    ),
    TransactionModel(
      id: 'tx-005', title: 'Central Online',
      description: 'เสื้อผ้า',
      amount: 2_890.00, type: TransactionType.expense,
      category: TransactionCategory.shopping,
      date: DateTime.now().subtract(const Duration(days: 2)),
      accountId: 'acc-002',
    ),
    TransactionModel(
      id: 'tx-006', title: 'ค่าไฟฟ้า MEA',
      description: 'การไฟฟ้านครหลวง',
      amount: 1_850.00, type: TransactionType.expense,
      category: TransactionCategory.bills,
      date: DateTime.now().subtract(const Duration(days: 3)),
      accountId: 'acc-002',
    ),
    TransactionModel(
      id: 'tx-007', title: 'Netflix',
      description: 'Premium Plan',
      amount: 419.00, type: TransactionType.expense,
      category: TransactionCategory.entertainment,
      date: DateTime.now().subtract(const Duration(days: 4)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-008', title: 'เงินปันผล',
      description: 'กองทุน LTF',
      amount: 3_200.00, type: TransactionType.income,
      category: TransactionCategory.investment,
      date: DateTime.now().subtract(const Duration(days: 5)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-009', title: 'โรงพยาบาล',
      description: 'ตรวจสุขภาพประจำปี',
      amount: 4_500.00, type: TransactionType.expense,
      category: TransactionCategory.health,
      date: DateTime.now().subtract(const Duration(days: 6)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-010', title: 'Udemy Course',
      description: 'Flutter Masterclass',
      amount: 390.00, type: TransactionType.expense,
      category: TransactionCategory.education,
      date: DateTime.now().subtract(const Duration(days: 7)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-011', title: 'Figma Freelance',
      description: 'งานออกแบบ UI/UX',
      amount: 15_000.00, type: TransactionType.income,
      category: TransactionCategory.freelance,
      date: DateTime.now().subtract(const Duration(days: 8)),
      accountId: 'acc-001',
    ),
    TransactionModel(
      id: 'tx-012', title: 'ท็อปอัพเกม',
      description: 'ROV Diamond',
      amount: 790.00, type: TransactionType.expense,
      category: TransactionCategory.topUp,
      date: DateTime.now().subtract(const Duration(days: 9)),
      accountId: 'acc-001',
    ),
  ];

  // ── Queries ──────────────────────────────────────────────────────
  List<TransactionModel> getAll()                       => List.unmodifiable(_txs);
  TransactionModel? findById(String id)                 => _txs.where((t) => t.id == id).firstOrNull;
  List<TransactionModel> getRecent([int n = 5])         => _txs.take(n).toList();
  List<TransactionModel> byType(TransactionType type)   => _txs.where((t) => t.type == type).toList();
  List<TransactionModel> byAccount(String accountId)    => _txs.where((t) => t.accountId == accountId).toList();

  List<TransactionModel> filter({
    TransactionType? type,
    String? query,
    DateTimeRange? dateRange,
  }) {
    var list = _txs;
    if (type != null) list = list.where((t) => t.type == type).toList();
    if (dateRange != null) {
      list = list.where((t) =>
        t.date.isAfter(dateRange.start) && t.date.isBefore(dateRange.end)
      ).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((t) =>
        t.title.toLowerCase().contains(q) ||
        (t.description?.toLowerCase().contains(q) ?? false)
      ).toList();
    }
    return list;
  }

  // ── Analytics ────────────────────────────────────────────────────
  double getTotalIncome()    => _txs.where((t) => t.isIncome).fold(0, (s, t) => s + t.amount);
  double getTotalExpenses()  => _txs.where((t) => t.isExpense).fold(0, (s, t) => s + t.amount);
  double getNetBalance()     => getTotalIncome() - getTotalExpenses();

  Map<TransactionCategory, double> getSpendingByCategory() {
    final Map<TransactionCategory, double> result = {};
    for (final t in _txs.where((t) => t.isExpense)) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return Map.fromEntries(result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));
  }

  // ── Mutations ────────────────────────────────────────────────────
  Future<TransactionModel> add(TransactionModel tx) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _txs.insert(0, tx);
    return tx;
  }

  Future<TransactionModel> transfer({
    required String fromAccountId,
    required String toName,
    required String toBank,
    required double amount,
    String? note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final now = DateTime.now();
    final tx = TransactionModel(
      id: 'tx-${now.millisecondsSinceEpoch}',
      title: 'โอนเงิน',
      description: note ?? 'โอนให้ $toName',
      amount: amount,
      type: TransactionType.transfer,
      category: TransactionCategory.transfer,
      date: now,
      recipientName: toName,
      recipientBank: toBank,
      accountId: fromAccountId,
      referenceId: 'REF${now.millisecondsSinceEpoch}',
    );
    _txs.insert(0, tx);
    return tx;
  }
}
