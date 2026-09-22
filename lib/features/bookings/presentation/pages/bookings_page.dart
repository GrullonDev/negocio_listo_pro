import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_event.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_state.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/widgets/add_booking_bottom_sheet.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citas y Pedidos')),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading || state is BookingInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingError) {
            return Center(child: Text(state.message));
          } else if (state is BookingLoaded) {
            return _BookingsList(bookings: state.bookings);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddBookingBottomSheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva cita'),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<BookingEntity> bookings;

  const _BookingsList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (bookings.isEmpty) {
      return Center(
        child: Text(
          'Aún no hay citas registradas',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BookingBloc>().add(const LoadBookings());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _statusColor(booking.status).withValues(
                  alpha: 0.12,
                ),
                child: Icon(
                  Icons.event_available,
                  color: _statusColor(booking.status),
                ),
              ),
              title: Text(booking.clientName),
              subtitle: Text(
                '${booking.service} · ${booking.date.day}/${booking.date.month}/${booking.date.year}',
              ),
              trailing: Text(
                _statusLabel(booking.status),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: _statusColor(booking.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  String _statusLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pendiente';
      case BookingStatus.confirmed:
        return 'Confirmada';
      case BookingStatus.completed:
        return 'Completada';
      case BookingStatus.cancelled:
        return 'Cancelada';
    }
  }
}
