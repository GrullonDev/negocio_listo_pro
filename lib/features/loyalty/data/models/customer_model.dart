import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';

part 'customer_model.g.dart';

@collection
class CustomerModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String customerId;

  late String name;
  late String phone;
  late int points;

  @enumerated
  late LoyaltyTier tier;

  List<DateTime> visitHistory = [];

  CustomerModel();

  CustomerLoyaltyEntity toEntity() {
    return CustomerLoyaltyEntity(
      id: customerId,
      name: name,
      phone: phone,
      points: points,
      tier: tier,
      visitHistory: visitHistory,
    );
  }

  static CustomerModel fromEntity(CustomerLoyaltyEntity entity) {
    return CustomerModel()
      ..customerId = entity.id
      ..name = entity.name
      ..phone = entity.phone
      ..points = entity.points
      ..tier = entity.tier
      ..visitHistory = entity.visitHistory;
  }
}
