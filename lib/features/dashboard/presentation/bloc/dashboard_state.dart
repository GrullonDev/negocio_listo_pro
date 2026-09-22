import 'package:negocio_listo_pro/features/dashboard/domain/entities/financial_metrics_entity.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final FinancialMetricsEntity metrics;

  const DashboardLoaded(this.metrics);
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);
}
