import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/financial_metrics_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardMetricsUseCase
    implements UseCase<FinancialMetricsEntity, NoParams> {
  final DashboardRepository repository;

  const GetDashboardMetricsUseCase(this.repository);

  @override
  Future<Either<Failure, FinancialMetricsEntity>> call(NoParams params) {
    return repository.getMetrics();
  }
}
