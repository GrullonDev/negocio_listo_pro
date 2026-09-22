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
