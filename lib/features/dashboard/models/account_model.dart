// lib/features/dashboard/models/account_model.dart

import 'package:flutter/material.dart';

enum AccountType { savings, checking, credit }
enum AccountStatus { active, frozen, closed }

class AccountModel {
  final String id;
  final String name;
  final AccountType type;
  final AccountStatus status;
  final double balance;
  final String accountNumber;
  final String currency;
  final DateTime openedAt;

  const AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.accountNumber,
    this.status = AccountStatus.active,
    this.currency = '฿',
    required this.openedAt,
  });

  String get maskedNumber =>
      '••••${accountNumber.substring(accountNumber.length - 4)}';

  bool get isActive => status == AccountStatus.active;
  bool get isCreditAccount => type == AccountType.credit;

  String get typeLabel => switch (type) {
    AccountType.savings  => 'บัญชีออมทรัพย์',
    AccountType.checking => 'บัญชีกระแสรายวัน',
    AccountType.credit   => 'บัตรเครดิต',
  };

  Color get typeColor => switch (type) {
    AccountType.savings  => const Color(0xFF10B981),
    AccountType.checking => const Color(0xFF6366F1),
    AccountType.credit   => const Color(0xFFEF4444),
  };

  AccountModel copyWith({AccountStatus? status, double? balance}) => AccountModel(
    id: id, name: name, type: type,
    balance: balance ?? this.balance,
    accountNumber: accountNumber,
    status: status ?? this.status,
    currency: currency, openedAt: openedAt,
  );
}
