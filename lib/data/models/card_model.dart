// ─────────────────────────────────────────────
// Model: CardModel
// Represents a debit or credit card.
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Card payment network
enum CardNetwork { visa, mastercard, unionpay }

/// Card tier / tier level
enum CardTier { standard, gold, platinum, infinite }

/// Whether card is debit or credit
enum CardCategory { debit, credit }

/// Card lock status
enum CardStatus { active, locked, expired, cancelled }

class CardModel {
  final String id;
  final String cardNumber;   // e.g., "4532 1234 5678 9012"
  final String holderName;   // uppercase, e.g., "WARINTHON K."
  final String expiryDate;   // "MM/YY"
  final String cvv;
  final CardNetwork network;
  final CardTier tier;
  final CardCategory category;
  final CardStatus status;
  final double balance;
  final double spendingLimit;
  final double currentSpending;
  final String linkedAccountId;
  final Color? customColor;  // optional gradient override

  const CardModel({
    required this.id,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.cvv,
    required this.network,
    required this.tier,
    required this.category,
    required this.linkedAccountId,
    required this.balance,
    this.status = CardStatus.active,
    this.spendingLimit = 0,
    this.currentSpending = 0,
    this.customColor,
  });

  // ── Getters ────────────────────────────────

  /// "•••• •••• •••• 9012"
  String get maskedNumber {
    final digits = cardNumber.replaceAll(' ', '');
    return '•••• •••• •••• ${digits.substring(digits.length - 4)}';
  }

  /// Last 4 digits only: "9012"
  String get lastFour {
    final digits = cardNumber.replaceAll(' ', '');
    return digits.substring(digits.length - 4);
  }

  bool get isActive   => status == CardStatus.active;
  bool get isLocked   => status == CardStatus.locked;
  bool get isExpired  => status == CardStatus.expired;
  bool get isCreditCard => category == CardCategory.credit;

  /// Spending used / limit  (0.0 – 1.0)
  double get spendingPercentage =>
      spendingLimit > 0 ? (currentSpending / spendingLimit).clamp(0, 1) : 0;

  /// Remaining spending capacity
  double get remainingLimit => (spendingLimit - currentSpending).clamp(0, spendingLimit);

  String get tierLabel => switch (tier) {
    CardTier.standard => 'Standard',
    CardTier.gold     => 'Gold',
    CardTier.platinum => 'Platinum',
    CardTier.infinite => 'Infinite',
  };

  String get networkLabel => switch (network) {
    CardNetwork.visa      => 'Visa',
    CardNetwork.mastercard => 'Mastercard',
    CardNetwork.unionpay  => 'UnionPay',
  };

  /// Gradient colors based on tier
  List<Color> get gradientColors => switch (tier) {
    CardTier.standard => [const Color(0xFF64748B), const Color(0xFF475569)],
    CardTier.gold     => [const Color(0xFFF59E0B), const Color(0xFFD97706)],
    CardTier.platinum => [const Color(0xFF6366F1), const Color(0xFF8B5CF6), const Color(0xFFA855F7)],
    CardTier.infinite => [const Color(0xFF0F172A), const Color(0xFF1E293B)],
  };

  CardModel copyWith({
    CardStatus? status,
    double? currentSpending,
    double? balance,
  }) {
    return CardModel(
      id: id,
      cardNumber: cardNumber,
      holderName: holderName,
      expiryDate: expiryDate,
      cvv: cvv,
      network: network,
      tier: tier,
      category: category,
      status: status ?? this.status,
      balance: balance ?? this.balance,
      spendingLimit: spendingLimit,
      currentSpending: currentSpending ?? this.currentSpending,
      linkedAccountId: linkedAccountId,
      customColor: customColor,
    );
  }
}
