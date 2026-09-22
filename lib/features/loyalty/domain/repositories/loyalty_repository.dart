import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';

/// Contrato de persistencia de fidelización, resuelto íntegramente de
/// forma local con Isar — sin llamadas remotas.
abstract class LoyaltyRepository {
  Future<Either<Failure, List<CustomerLoyaltyEntity>>> getCustomers();
  Future<Either<Failure, void>> addCustomer(CustomerLoyaltyEntity customer);
  Future<Either<Failure, void>> addPoints(String customerId, int points);
}
