enum TransactionType { income, expense, transfer }
enum TransactionCategory {
  salary,
  food,
  transport,
  shopping,
  bills,
  entertainment,
  health,
  education,
  transfer,
  topUp,
  other,
}

class TransactionModel {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? recipientName;

  const TransactionModel({
    required this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.recipientName,
  });

  bool get isIncome => type == TransactionType.income;
  String get formattedAmount => '${isIncome ? '+' : '-'}฿${amount.toStringAsFixed(2)}';
}
