import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/platform_admin/presentation/bloc/platform_admin_bloc.dart';

class PlatformTenantsPage extends StatelessWidget {
  const PlatformTenantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Negocios')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<PlatformAdminBloc, PlatformAdminState>(
        listener: (context, state) {
          if (state is PlatformOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<PlatformAdminBloc>().add(PlatformTenantsRequested());
          }
          if (state is PlatformAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is PlatformAdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlatformTenantsLoaded) {
            if (state.tenants.isEmpty) {
              return const Center(child: Text('No hay negocios registrados'));
            }
            return ListView.builder(
              itemCount: state.tenants.length,
              itemBuilder: (context, index) {
                final t = state.tenants[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: t.status == 'active'
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    child: Icon(
                      Icons.store,
                      color: t.status == 'active'
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                  title: Text(t.name),
                  subtitle: Text(
                      '${t.businessType} • ${t.currencyCode} • ${t.status}'),
                  trailing: t.brandName != null
                      ? Chip(label: Text(t.brandName!))
                      : null,
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final ownerNameCtrl = TextEditingController();
    final ownerEmailCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Crear Negocio'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration:
                    const InputDecoration(labelText: 'Nombre del negocio'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ownerNameCtrl,
                decoration:
                    const InputDecoration(labelText: 'Nombre del dueño'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ownerEmailCtrl,
                decoration:
                    const InputDecoration(labelText: 'Email del dueño'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty &&
                  ownerNameCtrl.text.isNotEmpty &&
                  ownerEmailCtrl.text.isNotEmpty) {
                context.read<PlatformAdminBloc>().add(
                      PlatformCreateTenantRequested({
                        'name': nameCtrl.text,
                        'owner_name': ownerNameCtrl.text,
                        'owner_email': ownerEmailCtrl.text,
                      }),
                    );
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}
