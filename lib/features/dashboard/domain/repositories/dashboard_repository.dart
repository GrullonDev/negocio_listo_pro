import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/financial_metrics_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';

abstract class DashboardRepository {
  /// Reads and aggregates every locally persisted transaction. Fully
  /// offline — resolved entirely from the on-device Isar store.
  Future<Either<Failure, FinancialMetricsEntity>> getMetrics();

  /// Persists a new transaction locally.
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);
}
