// lib/features/auth/services/auth_service.dart

import '../models/user_model.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  UserModel? _currentUser;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;
  UserModel get user => _currentUser ?? _seed;

  Future<UserModel> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _currentUser = (_isLoggedIn = true, _seed).$2;
  }

  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _currentUser = (_isLoggedIn = true, _seed).$2;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _isLoggedIn = true;
    return _currentUser = UserModel(
      id: 'usr-new', fullName: name, email: email, phone: '',
      tier: MembershipTier.basic, promptPayId: '', joinedAt: DateTime.now(),
    );
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _isLoggedIn = false;
  }

  Future<UserModel> updateProfile({
    String? fullName, String? phone, String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentUser = user.copyWith(
      fullName: fullName, phone: phone, avatarUrl: avatarUrl,
    );
  }

  // ── Seed data ─────────────────────────────────────────────────────
  static final _seed = UserModel(
    id: 'usr-001',
    fullName: 'Warinthon K.',
    email: 'warinthon@luxbank.com',
    phone: '098-765-4321',
    tier: MembershipTier.platinum,
    promptPayId: '0987654321',
    joinedAt: DateTime(2022, 3, 15),
  );
}
