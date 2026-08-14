enum AccountType { savings, checking, credit }

class AccountModel {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String accountNumber;
  final String currency;

  const AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.accountNumber,
    this.currency = '฿',
  });

  String get maskedNumber => '••••${accountNumber.substring(accountNumber.length - 4)}';
}
