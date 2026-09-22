import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/repositories/dashboard_repository.dart';

class AddTransactionUseCase implements UseCase<void, TransactionEntity> {
  final DashboardRepository repository;

  const AddTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(TransactionEntity params) {
    return repository.addTransaction(params);
  }
}
