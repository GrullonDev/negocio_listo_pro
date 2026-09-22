import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/bookings/domain/repositories/booking_repository.dart';

class AddBookingUseCase implements UseCase<void, BookingEntity> {
  final BookingRepository repository;

  const AddBookingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(BookingEntity params) {
    return repository.addBooking(params);
  }
}
