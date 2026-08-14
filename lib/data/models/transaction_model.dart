// ─────────────────────────────────────────────
// Model: TransactionModel
// Represents a single financial transaction.
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Direction of money flow
enum TransactionType { income, expense, transfer }

/// Transaction status
enum TransactionStatus { pending, completed, failed, refunded }

/// Spending / income category
enum TransactionCategory {
  salary,
  freelance,
  investment,
  food,
  transport,
  shopping,
  bills,
  entertainment,
  health,
  education,
  transfer,
  topUp,
  other,
}

class TransactionModel {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final TransactionStatus status;
  final DateTime date;
  final String? recipientName;
  final String? recipientBank;
  final String? accountId;     // which account was used
  final String? referenceId;   // bank reference / slip number

  const TransactionModel({
    required this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.status = TransactionStatus.completed,
    this.recipientName,
    this.recipientBank,
    this.accountId,
    this.referenceId,
  });

  // ── Helpers ────────────────────────────────

  bool get isIncome   => type == TransactionType.income;
  bool get isExpense  => type == TransactionType.expense;
  bool get isTransfer => type == TransactionType.transfer;
  bool get isPending  => status == TransactionStatus.pending;
  bool get isFailed   => status == TransactionStatus.failed;

  /// "+฿85,000.00" or "-฿245.00"
  String get formattedAmount {
    final prefix = isIncome ? '+' : '-';
    final abs = amount.abs();
    return '$prefix฿${_formatNumber(abs)}';
  }

  /// Amount in signed double (positive = income, negative = expense/transfer)
  double get signedAmount => isIncome ? amount : -amount;

  String get statusLabel => switch (status) {
    TransactionStatus.pending  => 'กำลังดำเนินการ',
    TransactionStatus.completed => 'สำเร็จ',
    TransactionStatus.failed    => 'ล้มเหลว',
    TransactionStatus.refunded  => 'คืนเงินแล้ว',
  };

  Color get statusColor => switch (status) {
    TransactionStatus.pending   => const Color(0xFFF59E0B),
    TransactionStatus.completed => const Color(0xFF10B981),
    TransactionStatus.failed    => const Color(0xFFEF4444),
    TransactionStatus.refunded  => const Color(0xFF6366F1),
  };

  /// Amount color: green for income, red for expense
  Color get amountColor => isIncome
      ? const Color(0xFF10B981)
      : const Color(0xFFEF4444);

  /// Icon based on category
  IconData get categoryIcon => switch (category) {
    TransactionCategory.salary       => LucideIcons.briefcase,
    TransactionCategory.freelance    => LucideIcons.laptop,
    TransactionCategory.investment   => LucideIcons.trendingUp,
    TransactionCategory.food         => LucideIcons.utensils,
    TransactionCategory.transport    => LucideIcons.train,
    TransactionCategory.shopping     => LucideIcons.shoppingBag,
    TransactionCategory.bills        => LucideIcons.fileText,
    TransactionCategory.entertainment => LucideIcons.gamepad2,
    TransactionCategory.health       => LucideIcons.heartPulse,
    TransactionCategory.education    => LucideIcons.graduationCap,
    TransactionCategory.transfer     => LucideIcons.arrowLeftRight,
    TransactionCategory.topUp        => LucideIcons.smartphone,
    TransactionCategory.other        => LucideIcons.circle,
  };

  /// Color based on category
  Color get categoryColor => switch (category) {
    TransactionCategory.salary       => const Color(0xFF10B981),
    TransactionCategory.freelance    => const Color(0xFF10B981),
    TransactionCategory.investment   => const Color(0xFF6366F1),
    TransactionCategory.food         => const Color(0xFFF97316),
    TransactionCategory.transport    => const Color(0xFF06B6D4),
    TransactionCategory.shopping     => const Color(0xFFA855F7),
    TransactionCategory.bills        => const Color(0xFFF59E0B),
    TransactionCategory.entertainment => const Color(0xFF6366F1),
    TransactionCategory.health       => const Color(0xFFEF4444),
    TransactionCategory.education    => const Color(0xFF3B82F6),
    TransactionCategory.transfer     => const Color(0xFF6366F1),
    TransactionCategory.topUp        => const Color(0xFF22C55E),
    TransactionCategory.other        => const Color(0xFF94A3B8),
  };

  /// Thai display label
  String get categoryLabel => switch (category) {
    TransactionCategory.salary       => 'เงินเดือน',
    TransactionCategory.freelance    => 'ฟรีแลนซ์',
    TransactionCategory.investment   => 'การลงทุน',
    TransactionCategory.food         => 'อาหาร',
    TransactionCategory.transport    => 'เดินทาง',
    TransactionCategory.shopping     => 'ช้อปปิ้ง',
    TransactionCategory.bills        => 'ค่าบิล',
    TransactionCategory.entertainment => 'บันเทิง',
    TransactionCategory.health       => 'สุขภาพ',
    TransactionCategory.education    => 'การศึกษา',
    TransactionCategory.transfer     => 'โอนเงิน',
    TransactionCategory.topUp        => 'เติมเงิน',
    TransactionCategory.other        => 'อื่นๆ',
  };

  static String _formatNumber(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }
}
