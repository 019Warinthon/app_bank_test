// lib/features/dashboard/services/account_service.dart

import '../models/account_model.dart';

class AccountService {
  AccountService._();
  static final AccountService instance = AccountService._();

  final List<AccountModel> _accounts = [
    AccountModel(
      id: 'acc-001',
      name: 'บัญชีออมทรัพย์',
      type: AccountType.savings,
      balance: 285_750.50,
      accountNumber: '4821093756',
      openedAt: DateTime(2022, 3, 15),
    ),
    AccountModel(
      id: 'acc-002',
      name: 'บัญชีกระแสรายวัน',
      type: AccountType.checking,
      balance: 42_300.00,
      accountNumber: '4821093801',
      openedAt: DateTime(2023, 1, 10),
    ),
    AccountModel(
      id: 'acc-003',
      name: 'บัตรเครดิต Platinum',
      type: AccountType.credit,
      balance: -15_420.75,
      accountNumber: '5412789034',
      openedAt: DateTime(2023, 6, 1),
    ),
  ];

  List<AccountModel> getAll() => List.unmodifiable(_accounts);
  AccountModel? findById(String id) => _accounts.where((a) => a.id == id).firstOrNull;
  List<AccountModel> getActive() => _accounts.where((a) => a.isActive).toList();
  List<AccountModel> getDepositAccounts() => _accounts.where((a) => !a.isCreditAccount).toList();

  double getTotalBalance() =>
      _accounts.where((a) => a.balance > 0).fold(0.0, (s, a) => s + a.balance);

  Future<AccountModel> setStatus(String id, AccountStatus status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final i = _accounts.indexWhere((a) => a.id == id);
    if (i < 0) throw Exception('Account not found');
    return _accounts[i] = _accounts[i].copyWith(status: status);
  }

  Future<AccountModel> debit(String id, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final i = _accounts.indexWhere((a) => a.id == id);
    if (i < 0) throw Exception('Account not found');
    if (_accounts[i].balance < amount) throw Exception('Insufficient balance');
    return _accounts[i] = _accounts[i].copyWith(balance: _accounts[i].balance - amount);
  }

  Future<AccountModel> credit(String id, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final i = _accounts.indexWhere((a) => a.id == id);
    if (i < 0) throw Exception('Account not found');
    return _accounts[i] = _accounts[i].copyWith(balance: _accounts[i].balance + amount);
  }
}
