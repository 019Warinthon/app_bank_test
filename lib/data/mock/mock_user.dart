// lib/data/mock/mock_user.dart
// Mock data: current logged-in user.

import '../models/models.dart';

abstract final class MockUser {
  static final current = UserModel(
    id: 'usr-001',
    fullName: 'Warinthon K.',
    email: 'warinthon@luxbank.com',
    phone: '098-765-4321',
    avatarUrl: null,
    tier: MembershipTier.platinum,
    promptPayId: '0987654321',
    joinedAt: DateTime(2022, 3, 15),
  );
}
