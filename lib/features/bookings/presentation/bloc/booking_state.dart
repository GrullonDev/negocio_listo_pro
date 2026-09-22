import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';

abstract class BookingState {
  const BookingState();
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingLoaded extends BookingState {
  final List<BookingEntity> bookings;

  const BookingLoaded(this.bookings);
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);
}
