// lib/features/cards/services/card_service.dart

import '../models/card_model.dart';

class CardService {
  CardService._();
  static final CardService instance = CardService._();

  final List<CardModel> _cards = [
    CardModel(
      id: 'card-001',
      cardNumber: '4532 1234 5678 9012',
      holderName: 'WARINTHON K.',
      expiryDate: '12/28', cvv: '456',
      network: CardNetwork.visa,
      tier: CardTier.platinum,
      category: CardCategory.debit,
      balance: 285_750.50,
      spendingLimit: 100_000,
      currentSpending: 34_500,
      linkedAccountId: 'acc-001',
    ),
    CardModel(
      id: 'card-002',
      cardNumber: '5412 9876 5432 1098',
      holderName: 'WARINTHON K.',
      expiryDate: '06/27', cvv: '789',
      network: CardNetwork.mastercard,
      tier: CardTier.gold,
      category: CardCategory.credit,
      balance: 42_300.00,
      spendingLimit: 50_000,
      currentSpending: 15_420.75,
      linkedAccountId: 'acc-003',
    ),
  ];

  List<CardModel> getAll()         => List.unmodifiable(_cards);
  CardModel? findById(String id)   => _cards.where((c) => c.id == id).firstOrNull;
  List<CardModel> getActive()      => _cards.where((c) => c.isActive).toList();
  List<CardModel> getCreditCards() => _cards.where((c) => c.isCreditCard).toList();
  List<CardModel> getDebitCards()  => _cards.where((c) => !c.isCreditCard).toList();

  Future<CardModel> toggleLock(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final i = _cards.indexWhere((c) => c.id == id);
    if (i < 0) throw Exception('Card not found');
    final s = _cards[i].isLocked ? CardStatus.active : CardStatus.locked;
    return _cards[i] = _cards[i].copyWith(status: s);
  }

  Future<CardModel> cancel(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final i = _cards.indexWhere((c) => c.id == id);
    if (i < 0) throw Exception('Card not found');
    return _cards[i] = _cards[i].copyWith(status: CardStatus.cancelled);
  }

  Future<CardModel> recordSpending(String id, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final i = _cards.indexWhere((c) => c.id == id);
    if (i < 0) throw Exception('Card not found');
    final c = _cards[i];
    if (c.isCreditCard && c.currentSpending + amount > c.spendingLimit) {
      throw Exception('Credit limit exceeded');
    }
    return _cards[i] = c.copyWith(currentSpending: c.currentSpending + amount);
  }
}
