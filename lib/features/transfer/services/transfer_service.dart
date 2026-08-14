// lib/features/transfer/services/transfer_service.dart

import '../models/contact_model.dart';

class TransferService {
  TransferService._();
  static final TransferService instance = TransferService._();

  final List<TransferContact> _contacts = [
    const TransferContact(
      id: 'con-001',
      name: 'สมศรี ก.',
      bank: 'กสิกรไทย',
      accountNumber: '1234567890',
      avatar: 'S',
      isFavorite: true,
    ),
    const TransferContact(
      id: 'con-002',
      name: 'วิชัย ส.',
      bank: 'กรุงเทพ',
      accountNumber: '0987654321',
      avatar: 'W',
      isFavorite: true,
    ),
    const TransferContact(
      id: 'con-003',
      name: 'นิดา พ.',
      bank: 'ไทยพาณิชย์',
      accountNumber: '1122334455',
      avatar: 'N',
      isFavorite: false,
    ),
    const TransferContact(
      id: 'con-004',
      name: 'ธนา ล.',
      bank: 'กรุงไทย',
      accountNumber: '5544332211',
      avatar: 'T',
      isFavorite: false,
    ),
    const TransferContact(
      id: 'con-005',
      name: 'มินา จ.',
      bank: 'ทีเอ็มบีธนชาต',
      accountNumber: '9988776655',
      avatar: 'M',
      isFavorite: false,
    ),
  ];

  List<TransferContact> getContacts() => List.unmodifiable(_contacts);
  List<TransferContact> getFavorites() => _contacts.where((c) => c.isFavorite).toList();

  Future<bool> executeTransfer({
    required String recipientName,
    required String recipientBank,
    required String accountNumber,
    required double amount,
    String? note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}
