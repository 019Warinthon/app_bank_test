// ─────────────────────────────────────────────
// Model: UserModel
// Represents the currently logged-in user.
// ─────────────────────────────────────────────

/// Level of account membership
enum MembershipTier { basic, silver, gold, platinum }

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final MembershipTier tier;
  final String promptPayId;
  final DateTime joinedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.tier = MembershipTier.platinum,
    required this.promptPayId,
    required this.joinedAt,
  });

  /// Display initials (e.g., "WK" from "Warinthon K.")
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  String get tierLabel => switch (tier) {
    MembershipTier.basic    => 'Basic Member',
    MembershipTier.silver   => 'Silver Member',
    MembershipTier.gold     => 'Gold Member',
    MembershipTier.platinum => 'Platinum Member',
  };

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    MembershipTier? tier,
    String? promptPayId,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tier: tier ?? this.tier,
      promptPayId: promptPayId ?? this.promptPayId,
      joinedAt: joinedAt,
    );
  }
}
