import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/repositories/loyalty_repository.dart';

class AddPointsParams {
  final String customerId;
  final int points;

  const AddPointsParams({required this.customerId, required this.points});
}

class AddPointsToCustomerUseCase implements UseCase<void, AddPointsParams> {
  final LoyaltyRepository repository;

  const AddPointsToCustomerUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddPointsParams params) {
    return repository.addPoints(params.customerId, params.points);
  }
}
