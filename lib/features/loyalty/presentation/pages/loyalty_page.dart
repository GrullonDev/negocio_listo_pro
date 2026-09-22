import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_bloc.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_event.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_state.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/widgets/add_points_dialog.dart';

class LoyaltyPage extends StatelessWidget {
  const LoyaltyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoyaltyBloc, LoyaltyState>(
      builder: (context, state) {
        if (state is LoyaltyLoading || state is LoyaltyInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoyaltyError) {
          return Center(child: Text(state.message));
        } else if (state is LoyaltyLoaded) {
          return _CustomersScreen(customers: state.customers);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _CustomersScreen extends StatefulWidget {
  final List<CustomerLoyaltyEntity> customers;

  const _CustomersScreen({required this.customers});

  @override
  State<_CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<_CustomersScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  LoyaltyTier? _tierFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  DateTime? _lastVisit(CustomerLoyaltyEntity customer) {
    if (customer.visitHistory.isEmpty) return null;
    return customer.visitHistory.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  String _lastVisitLabel(CustomerLoyaltyEntity customer) {
    final last = _lastVisit(customer);
    if (last == null) return 'Sin visitas';
    final now = DateTime.now();
    final days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(last.year, last.month, last.day))
        .inDays;
    if (days <= 0) return 'Hoy';
    if (days == 1) return 'Ayer';
    return 'Hace $days días';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customers = widget.customers;

    final total = customers.length;
    final recurring = customers.where((c) => c.visitHistory.length > 1).length;
    final recurringPct = total == 0 ? 0 : ((recurring / total) * 100).round();
    final totalPoints = customers.fold<int>(0, (sum, c) => sum + c.points);

    final filtered = customers.where((c) {
      final matchesTier = _tierFilter == null || c.tier == _tierFilter;
      final matchesQuery =
          _query.isEmpty ||
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.phone.contains(_query);
      return matchesTier && matchesQuery;
    }).toList();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LoyaltyBloc>().add(const LoadCustomers());
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value.trim()),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o teléfono',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.dm),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.dm),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.people_alt,
                  label: 'Activos',
                  value: '$total',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatTile(
                  icon: Icons.autorenew,
                  label: 'Recurrencia',
                  value: '$recurringPct%',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatTile(
                  icon: Icons.stars,
                  label: 'Puntos activos',
                  value: totalPoints >= 1000
                      ? '${(totalPoints / 1000).toStringAsFixed(1)}k'
                      : '$totalPoints',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChipButton(
                  label: 'Todos ($total)',
                  selected: _tierFilter == null,
                  onTap: () => setState(() => _tierFilter = null),
                ),
                const SizedBox(width: 8),
                for (final tier in LoyaltyTier.values) ...[
                  _FilterChipButton(
                    label:
                        '${_tierLabel(tier)} (${customers.where((c) => c.tier == tier).length})',
                    color: _tierColor(context, tier),
                    selected: _tierFilter == tier,
                    onTap: () => setState(() => _tierFilter = tier),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  customers.isEmpty
                      ? 'Aún no hay clientes fidelizados'
                      : 'No se encontraron clientes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ...filtered.map(
              (customer) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
                child: _CustomerCard(
                  customer: customer,
                  tierColor: _tierColor(context, customer.tier),
                  tierLabel: _tierLabel(customer.tier),
                  lastVisitLabel: _lastVisitLabel(customer),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          _BenefitsLadderCard(tierColor: _tierColor, tierLabel: _tierLabel),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm + 4,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = color ?? scheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.full),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? accent : scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: selected ? _onColor(accent) : scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _onColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

class _CustomerCard extends StatelessWidget {
  final CustomerLoyaltyEntity customer;
  final Color tierColor;
  final String tierLabel;
  final String lastVisitLabel;

  const _CustomerCard({
    required this.customer,
    required this.tierColor,
    required this.tierLabel,
    required this.lastVisitLabel,
  });

  String _initials() {
    final parts = customer.name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm + 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: tierColor.withValues(alpha: 0.12),
                  child: Text(
                    _initials(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: tierColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customer.phone,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: tierColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium, size: 14, color: tierColor),
                      const SizedBox(width: 4),
                      Text(
                        tierLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: tierColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm + 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.dm),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Puntos',
                      value: '${customer.points} pts',
                    ),
                  ),
                  Expanded(
                    child: _MiniStat(
                      label: 'Visitas',
                      value: '${customer.visitHistory.length}',
                    ),
                  ),
                  Expanded(
                    child: _MiniStat(
                      label: 'Última visita',
                      value: lastVisitLabel,
                      valueColor: lastVisitLabel == 'Hoy' || lastVisitLabel == 'Ayer'
                          ? AppColors.success
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm + 4),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => AddPointsDialog.show(
                  context,
                  customerId: customer.id,
                  customerName: customer.name,
                ),
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Otorgar Puntos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MiniStat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _BenefitsLadderCard extends StatelessWidget {
  final Color Function(BuildContext, LoyaltyTier) tierColor;
  final String Function(LoyaltyTier) tierLabel;

  const _BenefitsLadderCard({required this.tierColor, required this.tierLabel});

  static const _ranges = {
    LoyaltyTier.bronze: '0-199 pts',
    LoyaltyTier.silver: '200-499 pts',
    LoyaltyTier.gold: '500-999 pts',
    LoyaltyTier.platinum: '1000+ pts',
  };

  static const _icons = {
    LoyaltyTier.bronze: Icons.emoji_events_outlined,
    LoyaltyTier.silver: Icons.emoji_events_outlined,
    LoyaltyTier.gold: Icons.emoji_events,
    LoyaltyTier.platinum: Icons.workspace_premium,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sell_outlined, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Escalafón de Niveles', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: LoyaltyTier.values.map((tier) {
                final color = tierColor(context, tier);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.dm),
                      ),
                      child: Column(
                        children: [
                          Icon(_icons[tier], size: 20, color: color),
                          const SizedBox(height: 6),
                          Text(
                            tierLabel(tier),
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _ranges[tier]!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
