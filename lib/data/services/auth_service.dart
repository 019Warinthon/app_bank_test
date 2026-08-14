// lib/data/services/auth_service.dart
// Service: Authentication & session management (mock implementation).

import '../models/models.dart';
import '../mock/mock_user.dart';

/// Simulates auth state for the mock app.
/// Replace internals with real API calls (Firebase, REST, etc.) later.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // ── State ────────────────────────────────────────────────────────
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  // ── Getters ──────────────────────────────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;

  // ── Auth Actions ─────────────────────────────────────────────────

  /// Sign in with email & password (mock: always succeeds).
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network
    _currentUser = MockUser.current;
    _isLoggedIn = true;
    return _currentUser!;
  }

  /// Sign in with Google OAuth (mock: always succeeds).
  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = MockUser.current;
    _isLoggedIn = true;
    return _currentUser!;
  }

  /// Register new user (mock: always succeeds).
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = UserModel(
      id: 'usr-new',
      fullName: name,
      email: email,
      phone: '',
      tier: MembershipTier.basic,
      promptPayId: '',
      joinedAt: DateTime.now(),
    );
    _isLoggedIn = true;
    return _currentUser!;
  }

  /// Sign out.
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _isLoggedIn = false;
  }

  /// Update user profile fields.
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = _currentUser?.copyWith(
      fullName: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
    );
    return _currentUser ?? MockUser.current;
  }
}
