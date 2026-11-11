import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/platform_admin/domain/entities/brand_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/presentation/bloc/platform_admin_bloc.dart';

class PlatformBrandsPage extends StatelessWidget {
  const PlatformBrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marcas')),
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
            context.read<PlatformAdminBloc>().add(PlatformBrandsRequested());
          }
        },
        builder: (context, state) {
          if (state is PlatformAdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlatformBrandsLoaded) {
            if (state.brands.isEmpty) {
              return const Center(child: Text('No hay marcas registradas'));
            }
            return ListView.builder(
              itemCount: state.brands.length,
              itemBuilder: (context, index) {
                final b = state.brands[index];
                return _BrandTile(brand: b);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final keyCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Crear Marca'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyCtrl,
              decoration:
                  const InputDecoration(labelText: 'Clave (ej: salon)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameCtrl,
              decoration:
                  const InputDecoration(labelText: 'Nombre de la marca'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (keyCtrl.text.isNotEmpty && nameCtrl.text.isNotEmpty) {
                context.read<PlatformAdminBloc>().add(
                      PlatformCreateBrandRequested({
                        'brand_key': keyCtrl.text,
                        'display_name': nameCtrl.text,
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

class _BrandTile extends StatelessWidget {
  final BrandEntity brand;
  const _BrandTile({required this.brand});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(brand.primaryColor);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(Icons.palette, color: color),
      ),
      title: Text(brand.displayName),
      subtitle: Text('${brand.brandKey} • ${brand.currencyCode}'),
      trailing: brand.isActive
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.cancel, color: Colors.red),
    );
  }

  Color _parseColor(String hex) {
    final clean = hex.replaceFirst('#', '');
    if (clean.length == 6) {
      return Color(int.parse('FF$clean', radix: 16));
    }
    return Colors.grey;
  }
}
