// lib/data/mock/mock_cards.dart
// Mock data: debit & credit cards for the current user.

import '../models/models.dart';

abstract final class MockCards {
  static final all = [
    CardModel(
      id: 'card-001',
      cardNumber: '4532 1234 5678 9012',
      holderName: 'WARINTHON K.',
      expiryDate: '12/28',
      cvv: '456',
      network: CardNetwork.visa,
      tier: CardTier.platinum,
      category: CardCategory.debit,
      status: CardStatus.active,
      balance: 285_750.50,
      spendingLimit: 100_000,
      currentSpending: 34_500,
      linkedAccountId: 'acc-001',
    ),
    CardModel(
      id: 'card-002',
      cardNumber: '5412 9876 5432 1098',
      holderName: 'WARINTHON K.',
      expiryDate: '06/27',
      cvv: '789',
      network: CardNetwork.mastercard,
      tier: CardTier.gold,
      category: CardCategory.credit,
      status: CardStatus.active,
      balance: 42_300.00,
      spendingLimit: 50_000,
      currentSpending: 15_420.75,
      linkedAccountId: 'acc-003',
    ),
  ];

  /// Find card by ID
  static CardModel? findById(String id) =>
      all.where((c) => c.id == id).firstOrNull;

  /// Only active cards
  static List<CardModel> get active =>
      all.where((c) => c.isActive).toList();

  /// Only credit cards
  static List<CardModel> get creditCards =>
      all.where((c) => c.isCreditCard).toList();

  /// Only debit cards
  static List<CardModel> get debitCards =>
      all.where((c) => !c.isCreditCard).toList();
}
