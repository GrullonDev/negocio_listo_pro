import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_event.dart';

/// Modal form to register a local booking/appointment. Only dispatches
/// [AddBookingRequested]; persistence is handled by [BookingBloc].
class AddBookingBottomSheet extends StatefulWidget {
  const AddBookingBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final bookingBloc = context.read<BookingBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: bookingBloc,
        child: const AddBookingBottomSheet(),
      ),
    );
  }

  @override
  State<AddBookingBottomSheet> createState() => _AddBookingBottomSheetState();
}

class _AddBookingBottomSheetState extends State<AddBookingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _clientController = TextEditingController();
  final _serviceController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _clientController.dispose();
    _serviceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<BookingBloc>().add(
      AddBookingRequested(
        BookingEntity(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          clientName: _clientController.text.trim(),
          service: _serviceController.text.trim(),
          date: _date,
          status: BookingStatus.pending,
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
            Text('Nueva cita', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clientController,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Ingresa el nombre del cliente'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _serviceController,
              decoration: const InputDecoration(
                labelText: 'Servicio',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Ingresa el servicio'
                  : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              leading: const Icon(Icons.event),
              title: Text(
                '${_date.day}/${_date.month}/${_date.year}',
              ),
              onTap: _pickDate,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Guardar cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
