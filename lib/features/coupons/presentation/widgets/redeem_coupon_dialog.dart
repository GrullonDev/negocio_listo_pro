import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_bloc.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_event.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/pages/scan_coupon_page.dart';

/// Diálogo rápido de caja para canjear un cupón por código. Solo
/// despacha [RedeemCouponRequested]; la validación de vigencia/usos
/// ocurre en Domain/Data.
class RedeemCouponDialog extends StatefulWidget {
  final String initialCode;

  const RedeemCouponDialog({super.key, this.initialCode = ''});

  static Future<void> show(BuildContext context, {String initialCode = ''}) {
    final couponBloc = context.read<CouponBloc>();
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: couponBloc,
        child: RedeemCouponDialog(initialCode: initialCode),
      ),
    );
  }

  /// Abre la cámara primero; si el cajero prefiere escribir o se escanea
  /// un código, muestra el diálogo (prellenado) para confirmar el canje.
  static Future<void> scanAndShow(BuildContext context) async {
    final code = await ScanCouponPage.scan(context);
    if (code == null || !context.mounted) return;
    await show(context, initialCode: code);
  }

  @override
  State<RedeemCouponDialog> createState() => _RedeemCouponDialogState();
}

class _RedeemCouponDialogState extends State<RedeemCouponDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _codeController = TextEditingController(text: widget.initialCode);

  Future<void> _scan() async {
    final code = await ScanCouponPage.scan(context);
    if (!mounted || code == null || code == ScanCouponPage.manualEntry) return;
    _codeController.text = code;
  }

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
          decoration: InputDecoration(
            labelText: 'Código del cupón',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              tooltip: 'Escanear QR',
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: _scan,
            ),
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
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(64, 40)),
          onPressed: _submit,
          child: const Text('Canjear'),
        ),
      ],
    );
  }
}
