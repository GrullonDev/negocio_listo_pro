import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/branding/brand_config.dart';
import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/financial_metrics_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/widgets/recent_transactions_list.dart';
import 'package:negocio_listo_pro/core/theme/responsive.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
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
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final FinancialMetricsEntity metrics;

  const _DashboardContent({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = metrics.netBalance >= 0;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const LoadDashboardMetrics());
      },
      child: ListView(
        padding: context.pagePadding,
        children: [
          _BalanceHeroCard(metrics: metrics, isPositive: isPositive),
          const SizedBox(height: AppSpacing.md),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // 4 columnas cuando hay espacio (tablet/horizontal), 2 en móvil.
              crossAxisCount: context.screenWidth >= 560 ? 4 : 2,
              mainAxisSpacing: AppSpacing.gutterMobile,
              crossAxisSpacing: AppSpacing.gutterMobile,
              // Alto fijo que crece con el escalado de texto: el antiguo
              // childAspectRatio desbordaba en pantallas angostas.
              mainAxisExtent: MediaQuery.textScalerOf(context).scale(112),
            ),
            children: [
              StatCard(
                label: 'Ingresos Totales',
                value: BrandConfig.current.formatMoney(metrics.totalIncome),
                icon: Icons.trending_up,
                color: AppColors.success,
              ),
              StatCard(
                label: 'Gastos Totales',
                value: BrandConfig.current.formatMoney(metrics.totalExpenses),
                icon: Icons.trending_down,
                color: theme.colorScheme.error,
              ),
              StatCard(
                label: 'Balance Neto',
                value: BrandConfig.current.formatMoney(metrics.netBalance),
                icon: Icons.account_balance_wallet,
                color: isPositive
                    ? theme.colorScheme.primary
                    : AppColors.warning,
              ),
              StatCard(
                label: 'Órdenes Registradas',
                value: '${metrics.orderCount}',
                icon: Icons.receipt_long,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Movimientos recientes',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '${metrics.recentTransactions.length} últimas',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: RecentTransactionsList(
                transactions: metrics.recentTransactions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Executive summary hero card highlighting net balance and the
/// income/expense breakdown, mirroring the "Ventas de hoy" pattern from the
/// product design reference.
class _BalanceHeroCard extends StatelessWidget {
  final FinancialMetricsEntity metrics;
  final bool isPositive;

  const _BalanceHeroCard({required this.metrics, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primaryContainer],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BALANCE NETO',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.75),
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: scheme.onPrimary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: scheme.onPrimary,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      isPositive ? 'Positivo' : 'Negativo',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              BrandConfig.current.formatMoney(metrics.netBalance),
              style: theme.textTheme.displayLarge?.copyWith(
                color: scheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(height: 1, color: scheme.onPrimary.withValues(alpha: 0.16)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Ingresos',
                  value: metrics.totalIncome,
                  icon: Icons.south_west,
                  iconColor: AppColors.onPrimaryPositive,
                  onPrimary: scheme.onPrimary,
                ),
              ),
              Container(
                height: 32,
                width: 1,
                color: scheme.onPrimary.withValues(alpha: 0.16),
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'Gastos',
                  value: metrics.totalExpenses,
                  icon: Icons.north_east,
                  iconColor: AppColors.onPrimaryNegative,
                  onPrimary: scheme.onPrimary,
                ),
              ),
              Container(
                height: 32,
                width: 1,
                color: scheme.onPrimary.withValues(alpha: 0.16),
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'Órdenes',
                  value: metrics.orderCount.toDouble(),
                  icon: Icons.receipt_long,
                  iconColor: scheme.onPrimary,
                  onPrimary: scheme.onPrimary,
                  isCount: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color iconColor;
  final Color onPrimary;
  final bool isCount;

  const _HeroMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.onPrimary,
    this.isCount = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: onPrimary.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            isCount
                ? value.toStringAsFixed(0)
                : BrandConfig.current.formatMoney(value),
            style: theme.textTheme.titleMedium?.copyWith(
              color: onPrimary,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
