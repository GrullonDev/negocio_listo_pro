import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/loyalty/data/models/customer_model.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';

abstract class LoyaltyLocalDataSource {
  Future<List<CustomerModel>> getCustomers();
  Future<void> addCustomer(CustomerModel customer);
  Future<void> addPoints(String customerId, int points);
}

class LoyaltyLocalDataSourceImpl implements LoyaltyLocalDataSource {
  final Isar isar;

  const LoyaltyLocalDataSourceImpl(this.isar);

  @override
  Future<List<CustomerModel>> getCustomers() {
    return isar.customerModels.where().sortByNameDesc().findAll();
  }

  @override
  Future<void> addCustomer(CustomerModel customer) async {
    await isar.writeTxn(() async {
      await isar.customerModels.put(customer);
    });
  }

  @override
  Future<void> addPoints(String customerId, int points) async {
    await isar.writeTxn(() async {
      final customer = await isar.customerModels
          .filter()
          .customerIdEqualTo(customerId)
          .findFirst();
      if (customer == null) {
        throw const CacheFailure('Cliente no encontrado');
      }

      final updatedPoints = customer.points + points;
      final updatedCustomer = CustomerModel()
        ..id = customer.id
        ..customerId = customer.customerId
        ..name = customer.name
        ..phone = customer.phone
        ..points = updatedPoints
        ..tier = _tierForPoints(updatedPoints)
        ..visitHistory = [...customer.visitHistory, DateTime.now()];

      await isar.customerModels.put(updatedCustomer);
    });
  }

  LoyaltyTier _tierForPoints(int points) {
    if (points >= 1000) return LoyaltyTier.platinum;
    if (points >= 500) return LoyaltyTier.gold;
    if (points >= 200) return LoyaltyTier.silver;
    return LoyaltyTier.bronze;
  }
}
