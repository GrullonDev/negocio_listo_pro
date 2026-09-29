import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_bloc.dart';
import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_event.dart';

/// Formulario modal para generar un cupón nuevo. Solo despacha
/// [CreateCouponRequested]; toda persistencia ocurre en [CouponBloc].
class CreateCouponBottomSheet extends StatefulWidget {
  const CreateCouponBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final couponBloc = context.read<CouponBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: couponBloc,
        child: const CreateCouponBottomSheet(),
      ),
    );
  }

  @override
  State<CreateCouponBottomSheet> createState() =>
      _CreateCouponBottomSheetState();
}

class _CreateCouponBottomSheetState extends State<CreateCouponBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _maxUsesController = TextEditingController(text: '1');
  DiscountType _discountType = DiscountType.percentage;
  DateTime _expirationDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _codeController.dispose();
    _valueController.dispose();
    _maxUsesController.dispose();
    super.dispose();
  }

  Future<void> _pickExpirationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() => _expirationDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final value = double.parse(_valueController.text.replaceAll(',', '.'));
    final maxUses = int.parse(_maxUsesController.text.trim());

    context.read<CouponBloc>().add(
      CreateCouponRequested(
        CouponEntity(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          code: _codeController.text.trim().toUpperCase(),
          discountType: _discountType,
          value: value,
          expirationDate: _expirationDate,
          maxUses: maxUses,
          currentUses: 0,
          isActive: true,
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
            Text('Nuevo cupón', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Código (ej. VERANO10)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Ingresa el código del cupón'
                  : null,
            ),
            const SizedBox(height: AppSpacing.gutterMobile),
            SegmentedButton<DiscountType>(
              segments: const [
                ButtonSegment(
                  value: DiscountType.percentage,
                  label: Text('Porcentaje'),
                  icon: Icon(Icons.percent),
                ),
                ButtonSegment(
                  value: DiscountType.fixedAmount,
                  label: Text('Monto fijo'),
                  icon: Icon(Icons.attach_money),
                ),
              ],
              selected: {_discountType},
              onSelectionChanged: (selection) =>
                  setState(() => _discountType = selection.first),
            ),
            const SizedBox(height: AppSpacing.gutterMobile),
            TextFormField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: _discountType == DiscountType.percentage
                    ? 'Porcentaje de descuento'
                    : 'Monto de descuento',
                suffixText: _discountType == DiscountType.percentage
                    ? '%'
                    : null,
                prefixText: _discountType == DiscountType.fixedAmount
                    ? '\$ '
                    : null,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                final parsed = double.tryParse(
                  (value ?? '').replaceAll(',', '.'),
                );
                if (parsed == null || parsed <= 0) {
                  return 'Ingresa un valor válido';
                }
                if (_discountType == DiscountType.percentage && parsed > 100) {
                  return 'El porcentaje no puede superar 100';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.gutterMobile),
            TextFormField(
              controller: _maxUsesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Usos máximos',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final parsed = int.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Ingresa un número de usos válido';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.gutterMobile),
            ListTile(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              leading: const Icon(Icons.event_busy),
              title: Text(
                'Expira: ${_expirationDate.day}/${_expirationDate.month}/${_expirationDate.year}',
              ),
              onTap: _pickExpirationDate,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Guardar cupón'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
