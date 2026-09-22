import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';

/// Contract for local-only booking persistence. Fully offline — backed
/// by Isar, never a remote service.
abstract class BookingRepository {
  Future<Either<Failure, List<BookingEntity>>> getBookings();
  Future<Either<Failure, void>> addBooking(BookingEntity booking);
}
