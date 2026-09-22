import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';

abstract class DashboardEvent {
  const DashboardEvent();
}

/// Loads/refreshes the aggregated metrics from local storage.
class LoadDashboardMetrics extends DashboardEvent {
  const LoadDashboardMetrics();
}

/// Persists a new transaction and refreshes the metrics.
class AddDashboardTransaction extends DashboardEvent {
  final TransactionEntity transaction;

  const AddDashboardTransaction(this.transaction);
}
