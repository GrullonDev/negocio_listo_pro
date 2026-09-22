import 'package:isar_community/isar.dart';
import 'package:negocio_listo_pro/features/auth/domain/entities/tenant_entity.dart';

part 'tenant_model.g.dart';

/// Embedded object: a [UserModel] always owns its tenant snapshot,
/// so it does not need its own Isar collection/id.
@embedded
class TenantModel {
  late String tenantId;
  late String name;
  late String subscriptionPlan;

  TenantModel();

  TenantEntity toEntity() {
    return TenantEntity(
      id: tenantId,
      name: name,
      subscriptionPlan: subscriptionPlan,
    );
  }

  static TenantModel fromEntity(TenantEntity entity) {
    return TenantModel()
      ..tenantId = entity.id
      ..name = entity.name
      ..subscriptionPlan = entity.subscriptionPlan;
  }

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel()
      ..tenantId = json['id'] as String
      ..name = json['name'] as String
      ..subscriptionPlan = json['subscription_plan'] as String;
  }
}
