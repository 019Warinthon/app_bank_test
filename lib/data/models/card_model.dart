enum CardType { visa, mastercard }
enum CardTier { standard, gold, platinum }

class CardModel {
  final String id;
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String cvv;
  final CardType type;
  final CardTier tier;
  final double balance;
  final double spendingLimit;
  final double currentSpending;
  final bool isLocked;

  const CardModel({
    required this.id,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.cvv,
    required this.type,
    required this.tier,
    required this.balance,
    required this.spendingLimit,
    required this.currentSpending,
    this.isLocked = false,
  });

  String get maskedNumber {
    final parts = cardNumber.replaceAll(' ', '');
    return '•••• •••• •••• ${parts.substring(parts.length - 4)}';
  }

  double get spendingPercentage =>
      spendingLimit > 0 ? (currentSpending / spendingLimit) : 0;
}
