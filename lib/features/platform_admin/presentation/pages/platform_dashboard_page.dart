import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/platform_admin/presentation/bloc/platform_admin_bloc.dart';
import 'package:negocio_listo_pro/features/platform_admin/presentation/pages/platform_brands_page.dart';
import 'package:negocio_listo_pro/features/platform_admin/presentation/pages/platform_tenants_page.dart';

class PlatformDashboardPage extends StatelessWidget {
  const PlatformDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Global'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<PlatformAdminBloc>().add(PlatformLogoutRequested());
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: BlocBuilder<PlatformAdminBloc, PlatformAdminState>(
        builder: (context, state) {
          if (state is PlatformAdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlatformDashboardLoaded) {
            final d = state.dashboard;
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PlatformAdminBloc>()
                    .add(PlatformDashboardRequested());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Hola, ${state.user.name}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _MetricRow(
                    children: [
                      _MetricCard(
                        label: 'Negocios',
                        value: '${d.totalTenants}',
                        icon: Icons.store,
                      ),
                      _MetricCard(
                        label: 'Activos',
                        value: '${d.activeTenants}',
                        icon: Icons.check_circle_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _MetricRow(
                    children: [
                      _MetricCard(
                        label: 'Usuarios',
                        value: '${d.totalUsers}',
                        icon: Icons.people_outline,
                      ),
                      _MetricCard(
                        label: 'Marcas',
                        value: '${d.totalBrands}',
                        icon: Icons.palette_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _goToTenants(context),
                          icon: const Icon(Icons.store),
                          label: const Text('Negocios'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _goToBrands(context),
                          icon: const Icon(Icons.palette),
                          label: const Text('Marcas'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Actividad reciente',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...d.recentActivity.map(
                    (a) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.history, size: 20),
                      title: Text(a.action),
                      subtitle: Text(
                          '${a.targetType} • ${a.actorName}'),
                      trailing: Text(
                        _formatDate(a.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is PlatformAdminError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _goToTenants(BuildContext context) {
    final bloc = context.read<PlatformAdminBloc>();
    bloc.add(PlatformTenantsRequested());
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const PlatformTenantsPage(),
        ),
      ),
    );
  }

  void _goToBrands(BuildContext context) {
    final bloc = context.read<PlatformAdminBloc>();
    bloc.add(PlatformBrandsRequested());
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const PlatformBrandsPage(),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _MetricRow extends StatelessWidget {
  final List<Widget> children;
  const _MetricRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children
          .map((c) => Expanded(child: c))
          .expand((w) => [w, const SizedBox(width: 8)])
          .toList()
        ..removeLast(),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
