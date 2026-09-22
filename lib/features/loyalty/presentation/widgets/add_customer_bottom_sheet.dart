import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_bloc.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_event.dart';

/// Formulario modal para registrar un cliente nuevo en el programa de
/// fidelización. Solo despacha [AddCustomerRequested].
class AddCustomerBottomSheet extends StatefulWidget {
  const AddCustomerBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddCustomerBottomSheet(),
    );
  }

  @override
  State<AddCustomerBottomSheet> createState() =>
      _AddCustomerBottomSheetState();
}

class _AddCustomerBottomSheetState extends State<AddCustomerBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoyaltyBloc>().add(
      AddCustomerRequested(
        CustomerLoyaltyEntity(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          points: 0,
          tier: LoyaltyTier.bronze,
          visitHistory: const [],
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nuevo cliente',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Ingresa el nombre del cliente'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Ingresa el teléfono'
                  : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Guardar cliente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
