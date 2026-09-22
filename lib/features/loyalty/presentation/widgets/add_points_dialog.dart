import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_bloc.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_event.dart';

/// Diálogo simple para sumar puntos a un cliente existente. Solo
/// despacha [AddPointsRequested]; el cálculo de nivel vive en Data.
class AddPointsDialog extends StatefulWidget {
  final String customerId;
  final String customerName;

  const AddPointsDialog({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  static Future<void> show(
    BuildContext context, {
    required String customerId,
    required String customerName,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AddPointsDialog(
        customerId: customerId,
        customerName: customerName,
      ),
    );
  }

  @override
  State<AddPointsDialog> createState() => _AddPointsDialogState();
}

class _AddPointsDialogState extends State<AddPointsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pointsController = TextEditingController();

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final points = int.parse(_pointsController.text.trim());

    context.read<LoyaltyBloc>().add(
      AddPointsRequested(customerId: widget.customerId, points: points),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sumar puntos a ${widget.customerName}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _pointsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Puntos',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            final points = int.tryParse(value?.trim() ?? '');
            if (points == null || points <= 0) {
              return 'Ingresa un número de puntos válido';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Guardar')),
      ],
    );
  }
}
