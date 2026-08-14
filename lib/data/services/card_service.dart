// lib/data/services/card_service.dart
// Service: Card management operations.

import '../models/models.dart';
import '../mock/mock_cards.dart';

class CardService {
  CardService._();
  static final CardService instance = CardService._();

  // ── In-memory state ──────────────────────────────────────────────
  final List<CardModel> _cards = List.from(MockCards.all);

  // ── Queries ──────────────────────────────────────────────────────

  List<CardModel> getAll() => List.unmodifiable(_cards);

  CardModel? findById(String id) =>
      _cards.where((c) => c.id == id).firstOrNull;

  List<CardModel> getActive() =>
      _cards.where((c) => c.isActive).toList();

  List<CardModel> getCreditCards() =>
      _cards.where((c) => c.isCreditCard).toList();

  List<CardModel> getDebitCards() =>
      _cards.where((c) => !c.isCreditCard).toList();

  // ── Mutations ────────────────────────────────────────────────────

  /// Toggle card lock/unlock.
  Future<CardModel> toggleLock(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _cards.indexWhere((c) => c.id == id);
    if (idx == -1) throw Exception('Card not found: $id');
    final card = _cards[idx];
    final newStatus = card.isLocked ? CardStatus.active : CardStatus.locked;
    final updated = card.copyWith(status: newStatus);
    _cards[idx] = updated;
    return updated;
  }

  /// Cancel a card permanently.
  Future<CardModel> cancel(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _cards.indexWhere((c) => c.id == id);
    if (idx == -1) throw Exception('Card not found: $id');
    final updated = _cards[idx].copyWith(status: CardStatus.cancelled);
    _cards[idx] = updated;
    return updated;
  }

  /// Record a spending transaction on a card.
  Future<CardModel> recordSpending(String id, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _cards.indexWhere((c) => c.id == id);
    if (idx == -1) throw Exception('Card not found: $id');
    final card = _cards[idx];
    if (card.isCreditCard && card.currentSpending + amount > card.spendingLimit) {
      throw Exception('Credit limit exceeded');
    }
    final updated = card.copyWith(
      currentSpending: card.currentSpending + amount,
    );
    _cards[idx] = updated;
    return updated;
  }
}
