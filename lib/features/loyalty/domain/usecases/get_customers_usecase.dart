import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/repositories/loyalty_repository.dart';

class GetCustomersUseCase
    implements UseCase<List<CustomerLoyaltyEntity>, NoParams> {
  final LoyaltyRepository repository;

  const GetCustomersUseCase(this.repository);

  @override
  Future<Either<Failure, List<CustomerLoyaltyEntity>>> call(NoParams params) {
    return repository.getCustomers();
  }
}
