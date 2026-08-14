// lib/data/mock/mock_accounts.dart
// Mock data: bank accounts for the current user.

import '../models/models.dart';

abstract final class MockAccounts {
  static final all = [
    AccountModel(
      id: 'acc-001',
      name: 'บัญชีออมทรัพย์',
      type: AccountType.savings,
      balance: 285_750.50,
      accountNumber: '4821093756',
      bankCode: 'LUX',
      status: AccountStatus.active,
      openedAt: DateTime(2022, 3, 15),
    ),
    AccountModel(
      id: 'acc-002',
      name: 'บัญชีกระแสรายวัน',
      type: AccountType.checking,
      balance: 42_300.00,
      accountNumber: '4821093801',
      bankCode: 'LUX',
      status: AccountStatus.active,
      openedAt: DateTime(2023, 1, 10),
    ),
    AccountModel(
      id: 'acc-003',
      name: 'บัตรเครดิต Platinum',
      type: AccountType.credit,
      balance: -15_420.75,
      accountNumber: '5412789034',
      bankCode: 'LUX',
      status: AccountStatus.active,
      openedAt: DateTime(2023, 6, 1),
    ),
  ];

  /// Sum of all positive balances (savings + checking only)
  static double get totalPositiveBalance =>
      all.where((a) => a.balance > 0).fold(0, (sum, a) => sum + a.balance);

  /// Find account by ID (returns null if not found)
  static AccountModel? findById(String id) =>
      all.where((a) => a.id == id).firstOrNull;

  /// Only active accounts
  static List<AccountModel> get active =>
      all.where((a) => a.isActive).toList();

  /// Only savings and checking (non-credit) accounts
  static List<AccountModel> get depositAccounts =>
      all.where((a) => !a.isCreditAccount).toList();
}
