import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_bloc.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_event.dart';

/// Diálogo rápido de caja para canjear un cupón por código. Solo
/// despacha [RedeemCouponRequested]; la validación de vigencia/usos
/// ocurre en Domain/Data.
class RedeemCouponDialog extends StatefulWidget {
  const RedeemCouponDialog({super.key});

  static Future<void> show(BuildContext context) {
    final couponBloc = context.read<CouponBloc>();
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: couponBloc,
        child: const RedeemCouponDialog(),
      ),
    );
  }

  @override
  State<RedeemCouponDialog> createState() => _RedeemCouponDialogState();
}

class _RedeemCouponDialogState extends State<RedeemCouponDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<CouponBloc>().add(
      RedeemCouponRequested(_codeController.text.trim().toUpperCase()),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Canjear cupón'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _codeController,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Código del cupón',
            border: OutlineInputBorder(),
          ),
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Ingresa el código del cupón'
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Canjear')),
      ],
    );
  }
}
