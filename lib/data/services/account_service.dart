// lib/data/services/account_service.dart
// Service: Bank account operations.

import '../models/models.dart';
import '../mock/mock_accounts.dart';

class AccountService {
  AccountService._();
  static final AccountService instance = AccountService._();

  // ── In-memory mutable state (simulates a local cache) ────────────
  final List<AccountModel> _accounts = List.from(MockAccounts.all);

  // ── Queries ──────────────────────────────────────────────────────

  /// All accounts for the current user.
  List<AccountModel> getAll() => List.unmodifiable(_accounts);

  /// Find account by ID. Returns null if not found.
  AccountModel? findById(String id) =>
      _accounts.where((a) => a.id == id).firstOrNull;

  /// Only active accounts.
  List<AccountModel> getActive() =>
      _accounts.where((a) => a.isActive).toList();

  /// Only savings + checking (non-credit).
  List<AccountModel> getDepositAccounts() =>
      _accounts.where((a) => !a.isCreditAccount).toList();

  /// Combined positive balance (savings + checking).
  double getTotalBalance() =>
      _accounts.where((a) => a.balance > 0).fold(0, (s, a) => s + a.balance);

  // ── Mutations ────────────────────────────────────────────────────

  /// Simulates locking/unlocking an account.
  Future<AccountModel> setStatus(String id, AccountStatus status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _accounts.indexWhere((a) => a.id == id);
    if (idx == -1) throw Exception('Account not found: $id');
    final updated = _accounts[idx].copyWith(status: status);
    _accounts[idx] = updated;
    return updated;
  }

  /// Simulates a debit from an account (e.g., after transfer).
  Future<AccountModel> debit(String id, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _accounts.indexWhere((a) => a.id == id);
    if (idx == -1) throw Exception('Account not found: $id');
    final acc = _accounts[idx];
    if (acc.balance < amount) throw Exception('Insufficient balance');
    final updated = acc.copyWith(balance: acc.balance - amount);
    _accounts[idx] = updated;
    return updated;
  }

  /// Simulates a credit into an account (e.g., after receiving transfer).
  Future<AccountModel> credit(String id, double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _accounts.indexWhere((a) => a.id == id);
    if (idx == -1) throw Exception('Account not found: $id');
    final acc = _accounts[idx];
    final updated = acc.copyWith(balance: acc.balance + amount);
    _accounts[idx] = updated;
    return updated;
  }
}
