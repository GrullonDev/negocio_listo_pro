import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/dashboard/domain/entities/financial_metrics_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/widgets/recent_transactions_list.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NegocioListo Pro - Dashboard')),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoaded) {
            return _DashboardContent(metrics: state.metrics);
          } else if (state is DashboardError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addSampleTransaction(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva transacción'),
      ),
    );
  }

  void _addSampleTransaction(BuildContext context) {
    final isIncome = DateTime.now().second.isEven;
    context.read<DashboardBloc>().add(
      AddDashboardTransaction(
        TransactionEntity(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          description: isIncome ? 'Venta de prueba' : 'Gasto de prueba',
          amount: isIncome ? 150.0 : 45.0,
          type: isIncome ? TransactionType.income : TransactionType.expense,
          date: DateTime.now(),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final FinancialMetricsEntity metrics;

  const _DashboardContent({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const LoadDashboardMetrics());
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              StatCard(
                label: 'Ingresos Totales',
                value: '\$${metrics.totalIncome.toStringAsFixed(2)}',
                icon: Icons.trending_up,
                color: Colors.green,
              ),
              StatCard(
                label: 'Gastos Totales',
                value: '\$${metrics.totalExpenses.toStringAsFixed(2)}',
                icon: Icons.trending_down,
                color: Colors.red,
              ),
              StatCard(
                label: 'Balance Neto',
                value: '\$${metrics.netBalance.toStringAsFixed(2)}',
                icon: Icons.account_balance_wallet,
                color: metrics.netBalance >= 0 ? Colors.blue : Colors.orange,
              ),
              StatCard(
                label: 'Órdenes Registradas',
                value: '${metrics.orderCount}',
                icon: Icons.receipt_long,
                color: Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Movimientos recientes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          RecentTransactionsList(transactions: metrics.recentTransactions),
        ],
      ),
    );
  }
}
