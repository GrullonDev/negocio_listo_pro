import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/repositories/loyalty_repository.dart';

class AddCustomerUseCase implements UseCase<void, CustomerLoyaltyEntity> {
  final LoyaltyRepository repository;

  const AddCustomerUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CustomerLoyaltyEntity params) {
    return repository.addCustomer(params);
  }
}
