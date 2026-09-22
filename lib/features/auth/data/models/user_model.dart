import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/auth/data/models/tenant_model.dart';
import 'package:negocio_listo_pro/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// Local, offline-first persisted session. There is at most one row:
/// [sessionId] is pinned to a constant so writes overwrite the prior
/// session instead of accumulating history.
@collection
class UserModel {
  Id id = Isar.autoIncrement;

  static const int sessionId = 1;

  @Index(unique: true, replace: true)
  late int fixedSessionId;

  late String userId;
  late String email;
  late String displayName;
  late String authToken;
  late TenantModel tenant;

  UserModel();

  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      email: email,
      displayName: displayName,
      tenant: tenant.toEntity(),
      authToken: authToken,
    );
  }

  static UserModel fromEntity(UserEntity entity) {
    return UserModel()
      ..fixedSessionId = sessionId
      ..userId = entity.id
      ..email = entity.email
      ..displayName = entity.displayName
      ..authToken = entity.authToken
      ..tenant = TenantModel.fromEntity(entity.tenant);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel()
      ..fixedSessionId = sessionId
      ..userId = json['id'] as String
      ..email = json['email'] as String
      ..displayName = json['display_name'] as String
      ..authToken = json['token'] as String
      ..tenant = TenantModel.fromJson(json['tenant'] as Map<String, dynamic>);
  }
}
