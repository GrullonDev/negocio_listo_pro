import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_event.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_state.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/widgets/add_booking_bottom_sheet.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  late DateTime _selectedDate = _stripTime(DateTime.now());

  static DateTime _stripTime(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading || state is BookingInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingError) {
          return Center(child: Text(state.message));
        } else if (state is BookingLoaded) {
          return _BookingsScreen(
            bookings: state.bookings,
            selectedDate: _selectedDate,
            onSelectDate: (date) => setState(() => _selectedDate = date),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _BookingsScreen extends StatelessWidget {
  final List<BookingEntity> bookings;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;

  const _BookingsScreen({
    required this.bookings,
    required this.selectedDate,
    required this.onSelectDate,
  });

  static const _monthNames = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  List<BookingEntity> _bookingsOn(DateTime day) {
    return bookings.where((b) {
      final d = b.date;
      return d.year == day.year && d.month == day.month && d.day == day.day;
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekStart = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final dayBookings = _bookingsOn(selectedDate);
    final resolvedCount = dayBookings
        .where(
          (b) =>
              b.status == BookingStatus.confirmed ||
              b.status == BookingStatus.completed,
        )
        .length;
    final occupancy = dayBookings.isEmpty
        ? 0.0
        : resolvedCount / dayBookings.length;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BookingBloc>().add(const LoadBookings());
      },
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_monthNames[selectedDate.month - 1]} ${selectedDate.year}',
                      style: theme.textTheme.headlineSmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successContainer,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isToday(selectedDate)
                                ? 'Hoy'
                                : _weekdayLabel(selectedDate.weekday),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.onSuccessContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _WeekStrip(
                  days: weekDays,
                  selectedDate: selectedDate,
                  bookingsCountFor: (d) => _bookingsOn(d).length,
                  onSelect: onSelectDate,
                ),
                const SizedBox(height: AppSpacing.md),
                _OccupancyCard(
                  scheduled: dayBookings.length,
                  resolved: resolvedCount,
                  occupancy: occupancy,
                ),
                const SizedBox(height: AppSpacing.md),
                if (dayBookings.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No hay citas para este día',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  ...List.generate(dayBookings.length, (index) {
                    final booking = dayBookings[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == dayBookings.length - 1
                            ? 0
                            : AppSpacing.sm + 4,
                      ),
                      child: _BookingTimelineTile(booking: booking),
                    );
                  }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => AddBookingBottomSheet.show(context),
                icon: const Icon(Icons.add),
                label: const Text('Nueva Cita'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String _weekdayLabel(int weekday) {
    const labels = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
    ];
    return labels[weekday - 1];
  }
}

class _WeekStrip extends StatelessWidget {
  final List<DateTime> days;
  final DateTime selectedDate;
  final int Function(DateTime day) bookingsCountFor;
  final ValueChanged<DateTime> onSelect;

  const _WeekStrip({
    required this.days,
    required this.selectedDate,
    required this.bookingsCountFor,
    required this.onSelect,
  });

  static const _dayLabels = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      height: 76,
      child: Row(
        children: List.generate(days.length, (index) {
          final day = days[index];
          final isSelected =
              day.year == selectedDate.year &&
              day.month == selectedDate.month &&
              day.day == selectedDate.day;
          final count = bookingsCountFor(day);

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == days.length - 1 ? 0 : 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: () => onSelect(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? scheme.primary
                        : scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _dayLabels[day.weekday - 1],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? scheme.onPrimary.withValues(alpha: 0.75)
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${day.day}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isSelected ? scheme.onPrimary : scheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (count > 0)
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? scheme.onPrimary
                                : AppColors.success,
                          ),
                        )
                      else
                        const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _OccupancyCard extends StatelessWidget {
  final int scheduled;
  final int resolved;
  final double occupancy;

  const _OccupancyCard({
    required this.scheduled,
    required this.resolved,
    required this.occupancy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.donut_large,
                      size: 18,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ocupación estimada',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                Text(
                  '${(occupancy * 100).round()}%',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: occupancy,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation(AppColors.success),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$resolved de $scheduled citas confirmadas',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${scheduled - resolved} pendientes',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingTimelineTile extends StatelessWidget {
  final BookingEntity booking;

  const _BookingTimelineTile({required this.booking});

  Color _statusColor(BuildContext context) {
    switch (booking.status) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.confirmed:
        return Theme.of(context).colorScheme.primary;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return Theme.of(context).colorScheme.error;
    }
  }

  String _statusLabel() {
    switch (booking.status) {
      case BookingStatus.pending:
        return 'Por confirmar';
      case BookingStatus.confirmed:
        return 'Confirmada';
      case BookingStatus.completed:
        return 'Completada';
      case BookingStatus.cancelled:
        return 'Cancelada';
    }
  }

  String _initials() {
    final parts = booking.clientName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 && parts.last.isNotEmpty
        ? parts.last[0]
        : '';
    return (first + second).toUpperCase();
  }

  String _time() {
    final hour = booking.date.hour;
    final minute = booking.date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(
              _time(),
              textAlign: TextAlign.right,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm + 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: color.withValues(alpha: 0.12),
                          child: Text(
                            _initials(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.clientName,
                                style: theme.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                booking.service,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            _statusLabel(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
