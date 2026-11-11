class PlatformUserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool mustChangePassword;

  const PlatformUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.mustChangePassword = false,
  });
}
