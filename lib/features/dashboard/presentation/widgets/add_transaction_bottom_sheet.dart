import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_event.dart';

/// Modal form to register a local income/expense transaction. Only
/// dispatches [AddDashboardTransaction]; all persistence happens in
/// [DashboardBloc].
class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final dashboardBloc = context.read<DashboardBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: dashboardBloc,
        child: const AddTransactionBottomSheet(),
      ),
    );
  }

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _type = TransactionType.income;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.replaceAll(',', '.'));

    context.read<DashboardBloc>().add(
      AddDashboardTransaction(
        TransactionEntity(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          description: _descriptionController.text.trim(),
          amount: amount,
          type: _type,
          date: DateTime.now(),
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Desplazable: en teléfonos pequeños el teclado deja poco alto útil.
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        // viewPadding: deja libre la barra de navegación del sistema
        // (gestos/botones) para que no tape el botón de guardar.
        bottom:
            AppSpacing.md +
            MediaQuery.viewInsetsOf(context).bottom +
            MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nueva transacción',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Ingreso'),
                  icon: Icon(Icons.trending_up),
                ),
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Gasto'),
                  icon: Icon(Icons.trending_down),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selection) =>
                  setState(() => _type = selection.first),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Ingresa una descripción'
                  : null,
            ),
            const SizedBox(height: AppSpacing.gutterMobile),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa un monto';
                }
                final parsed = double.tryParse(value.replaceAll(',', '.'));
                if (parsed == null || parsed <= 0) {
                  return 'Ingresa un monto válido';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
