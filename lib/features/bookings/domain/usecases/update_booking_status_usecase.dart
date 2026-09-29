import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/bookings/domain/repositories/booking_repository.dart';

class UpdateBookingStatusParams {
  final String bookingId;
  final BookingStatus status;

  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
  });
}

class UpdateBookingStatusUseCase
    implements UseCase<void, UpdateBookingStatusParams> {
  final BookingRepository repository;

  const UpdateBookingStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateBookingStatusParams params) {
    return repository.updateBookingStatus(params.bookingId, params.status);
  }
}
