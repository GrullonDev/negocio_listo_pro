import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';

/// Aggregated snapshot of the tenant's local financial activity, derived
/// from the persisted [TransactionEntity] list.
class FinancialMetricsEntity {
  final double totalIncome;
  final double totalExpenses;
  final int orderCount;
  final List<TransactionEntity> recentTransactions;

  const FinancialMetricsEntity({
    required this.totalIncome,
    required this.totalExpenses,
    required this.orderCount,
    required this.recentTransactions,
  });

  double get netBalance => totalIncome - totalExpenses;
}
