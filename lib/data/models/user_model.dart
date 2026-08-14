class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String phone;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.phone,
  });
}
