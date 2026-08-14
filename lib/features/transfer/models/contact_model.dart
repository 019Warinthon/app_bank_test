// lib/features/transfer/models/contact_model.dart

class TransferContact {
  final String id;
  final String name;
  final String bank;
  final String accountNumber;
  final String avatar;
  final String? avatarUrl;
  final bool isFavorite;

  const TransferContact({
    required this.id,
    required this.name,
    required this.bank,
    required this.accountNumber,
    required this.avatar,
    this.avatarUrl,
    this.isFavorite = false,
  });
}
