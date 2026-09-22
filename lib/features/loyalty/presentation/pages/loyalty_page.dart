import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        padding: const EdgeInsets.all(16),
        itemCount: customers.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _tierColor(customer.tier).withValues(
                  alpha: 0.12,
                ),
                child: Icon(Icons.star, color: _tierColor(customer.tier)),
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
                      color: _tierColor(customer.tier),
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

  Color _tierColor(LoyaltyTier tier) {
    switch (tier) {
      case LoyaltyTier.bronze:
        return Colors.brown;
      case LoyaltyTier.silver:
        return Colors.blueGrey;
      case LoyaltyTier.gold:
        return Colors.amber;
      case LoyaltyTier.platinum:
        return Colors.deepPurple;
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
