import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';

abstract class BookingEvent {
  const BookingEvent();
}

class LoadBookings extends BookingEvent {
  const LoadBookings();
}

class AddBookingRequested extends BookingEvent {
  final BookingEntity booking;

  const AddBookingRequested(this.booking);
}

class UpdateBookingStatusRequested extends BookingEvent {
  final String bookingId;
  final BookingStatus status;

  const UpdateBookingStatusRequested({
    required this.bookingId,
    required this.status,
  });
}
