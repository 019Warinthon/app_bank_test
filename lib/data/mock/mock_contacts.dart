// lib/data/mock/mock_contacts.dart
// Mock data: saved contacts for quick transfer.

class TransferContact {
  final String id;
  final String name;
  final String bank;
  final String accountNumber;
  final String avatar;       // initials fallback
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

abstract final class MockContacts {
  static const all = [
    TransferContact(
      id: 'con-001',
      name: 'สมศรี ก.',
      bank: 'กสิกรไทย',
      accountNumber: '1234567890',
      avatar: 'S',
      isFavorite: true,
    ),
    TransferContact(
      id: 'con-002',
      name: 'วิชัย ส.',
      bank: 'กรุงเทพ',
      accountNumber: '0987654321',
      avatar: 'W',
      isFavorite: true,
    ),
    TransferContact(
      id: 'con-003',
      name: 'นิดา พ.',
      bank: 'ไทยพาณิชย์',
      accountNumber: '1122334455',
      avatar: 'N',
      isFavorite: false,
    ),
    TransferContact(
      id: 'con-004',
      name: 'ธนา ล.',
      bank: 'กรุงไทย',
      accountNumber: '5544332211',
      avatar: 'T',
      isFavorite: false,
    ),
    TransferContact(
      id: 'con-005',
      name: 'มินา จ.',
      bank: 'ทีเอ็มบีธนชาต',
      accountNumber: '9988776655',
      avatar: 'M',
      isFavorite: false,
    ),
  ];

  static List<TransferContact> get favorites =>
      all.where((c) => c.isFavorite).toList();
}
