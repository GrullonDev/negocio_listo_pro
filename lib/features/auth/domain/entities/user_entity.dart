import 'package:negocio_listo_pro/features/auth/domain/entities/tenant_entity.dart';

/// Domain-level representation of an authenticated user session.
/// Framework-free: no Isar/Dio annotations belong here.
class UserEntity {
  final String id;
  final String email;
  final String displayName;
  final TenantEntity tenant;
  final String authToken;

  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.tenant,
    required this.authToken,
  });
}
