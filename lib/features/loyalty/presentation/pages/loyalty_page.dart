import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_bloc.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_event.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_state.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/widgets/add_customer_bottom_sheet.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/widgets/add_points_dialog.dart';

class LoyaltyPage extends StatelessWidget {
  const LoyaltyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes Fidelizados')),
      body: BlocBuilder<LoyaltyBloc, LoyaltyState>(
        builder: (context, state) {
          if (state is LoyaltyLoading || state is LoyaltyInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoyaltyError) {
            return Center(child: Text(state.message));
          } else if (state is LoyaltyLoaded) {
            return _CustomersList(customers: state.customers);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddCustomerBottomSheet.show(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo cliente'),
      ),
    );
  }
}

class _CustomersList extends StatelessWidget {
  final List<CustomerLoyaltyEntity> customers;

  const _CustomersList({required this.customers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (customers.isEmpty) {
      return Center(
        child: Text(
          'Aún no hay clientes fidelizados',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LoyaltyBloc>().add(const LoadCustomers());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: customers.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final customer = customers[index];
          final tierColor = _tierColor(context, customer.tier);
          return Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: tierColor.withValues(alpha: 0.12),
                child: Icon(Icons.star, color: tierColor),
              ),
              title: Text(customer.name),
              subtitle: Text(
                '${customer.phone} · ${customer.visitHistory.length} visitas',
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${customer.points} pts',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: tierColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _tierLabel(customer.tier),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              onTap: () => AddPointsDialog.show(
                context,
                customerId: customer.id,
                customerName: customer.name,
              ),
            ),
          );
        },
      ),
    );
  }

  Color _tierColor(BuildContext context, LoyaltyTier tier) {
    final scheme = Theme.of(context).colorScheme;
    switch (tier) {
      case LoyaltyTier.bronze:
        return Colors.brown;
      case LoyaltyTier.silver:
        return scheme.onSurfaceVariant;
      case LoyaltyTier.gold:
        return AppColors.warning;
      case LoyaltyTier.platinum:
        return scheme.primary;
    }
  }

  String _tierLabel(LoyaltyTier tier) {
    switch (tier) {
      case LoyaltyTier.bronze:
        return 'Bronce';
      case LoyaltyTier.silver:
        return 'Plata';
      case LoyaltyTier.gold:
        return 'Oro';
      case LoyaltyTier.platinum:
        return 'Platino';
    }
  }
}
