// lib/data/services/transaction_service.dart
// Service: Transaction queries, filtering, and analytics.

import 'package:flutter/material.dart' show DateTimeRange;
import '../models/models.dart';
import '../mock/mock_transactions.dart';

class TransactionService {
  TransactionService._();
  static final TransactionService instance = TransactionService._();

  // ── In-memory state ──────────────────────────────────────────────
  final List<TransactionModel> _transactions = List.from(MockTransactions.all);

  // ── Basic Queries ────────────────────────────────────────────────

  List<TransactionModel> getAll() => List.unmodifiable(_transactions);

  TransactionModel? findById(String id) =>
      _transactions.where((t) => t.id == id).firstOrNull;

  List<TransactionModel> getRecent([int count = 5]) =>
      _transactions.take(count).toList();

  // ── Filtered Queries ─────────────────────────────────────────────

  List<TransactionModel> getByType(TransactionType type) =>
      _transactions.where((t) => t.type == type).toList();

  List<TransactionModel> getByCategory(TransactionCategory category) =>
      _transactions.where((t) => t.category == category).toList();

  List<TransactionModel> getByAccount(String accountId) =>
      _transactions.where((t) => t.accountId == accountId).toList();

  List<TransactionModel> getByStatus(TransactionStatus status) =>
      _transactions.where((t) => t.status == status).toList();

  /// Full-text search on title + description.
  List<TransactionModel> search(String query) {
    if (query.trim().isEmpty) return getAll();
    final q = query.toLowerCase();
    return _transactions.where((t) {
      return t.title.toLowerCase().contains(q) ||
          (t.description?.toLowerCase().contains(q) ?? false) ||
          (t.recipientName?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  /// Filter by both type and search query.
  List<TransactionModel> filter({
    TransactionType? type,
    String? query,
    TransactionCategory? category,
    DateTimeRange? dateRange,
  }) {
    var list = _transactions;
    if (type != null) list = list.where((t) => t.type == type).toList();
    if (category != null) list = list.where((t) => t.category == category).toList();
    if (dateRange != null) {
      list = list.where((t) =>
        t.date.isAfter(dateRange.start) &&
        t.date.isBefore(dateRange.end)
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

  double getTotalIncome() => _transactions
      .where((t) => t.isIncome)
      .fold(0, (s, t) => s + t.amount);

  double getTotalExpenses() => _transactions
      .where((t) => t.isExpense)
      .fold(0, (s, t) => s + t.amount);

  double getNetBalance() => getTotalIncome() - getTotalExpenses();

  /// Spending totals grouped by category.
  Map<TransactionCategory, double> getSpendingByCategory() {
    final Map<TransactionCategory, double> result = {};
    for (final t in _transactions.where((t) => t.isExpense)) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return Map.fromEntries(
      result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
  }

  // ── Mutations ────────────────────────────────────────────────────

  /// Add a new transaction (e.g., after a transfer is confirmed).
  Future<TransactionModel> addTransaction(TransactionModel tx) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _transactions.insert(0, tx); // newest first
    return tx;
  }

  /// Create a transfer transaction pair (debit + credit).
  Future<List<TransactionModel>> transfer({
    required String fromAccountId,
    required String toName,
    required String toBank,
    required double amount,
    String? note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final now = DateTime.now();
    final refId = 'REF${now.millisecondsSinceEpoch}';

    final debit = TransactionModel(
      id: 'tx-${now.millisecondsSinceEpoch}',
      title: 'โอนเงิน',
      description: note ?? 'โอนให้ $toName',
      amount: amount,
      type: TransactionType.transfer,
      category: TransactionCategory.transfer,
      status: TransactionStatus.completed,
      date: now,
      recipientName: toName,
      recipientBank: toBank,
      accountId: fromAccountId,
      referenceId: refId,
    );

    _transactions.insert(0, debit);
    return [debit];
  }
}
