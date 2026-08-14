// lib/data/mock/mock_data.dart
// ──────────────────────────────────────────────────────────────────────────────
// COMPATIBILITY SHIM — kept so existing imports still compile during migration.
// Prefer using the split files directly:
//
//   import 'package:app_bank_test/data/mock/mock.dart';
//
// or individually:
//   import 'package:app_bank_test/data/mock/mock_user.dart';
//   import 'package:app_bank_test/data/mock/mock_accounts.dart';
//   import 'package:app_bank_test/data/mock/mock_cards.dart';
//   import 'package:app_bank_test/data/mock/mock_transactions.dart';
//   import 'package:app_bank_test/data/mock/mock_contacts.dart';
// ──────────────────────────────────────────────────────────────────────────────

import '../models/models.dart';
import 'mock_user.dart';
import 'mock_accounts.dart';
import 'mock_cards.dart';
import 'mock_transactions.dart';
import 'mock_contacts.dart';

/// @deprecated Use [MockUser], [MockAccounts], [MockCards], [MockTransactions],
/// [MockContacts] from 'mock.dart' instead.
class MockData {
  MockData._();

  static UserModel get user => MockUser.current;

  static List<AccountModel> get accounts => MockAccounts.all;

  static List<CardModel> get cards => MockCards.all;

  static List<TransactionModel> get transactions => MockTransactions.all;

  static List<Map<String, Object>> get monthlySpending =>
      MockTransactions.monthlyData
          .map((e) => e.map((k, v) => MapEntry(k, v)))
          .toList();

  static List<Map<String, Object>> get categorySpending =>
      MockTransactions.categoryBreakdown
          .map((e) => e.map((k, v) => MapEntry(k, v)))
          .toList();

  static List<Map<String, String>> get quickContacts =>
      MockContacts.all
          .map((c) => {'name': c.name, 'bank': c.bank, 'avatar': c.avatar})
          .toList();
}
