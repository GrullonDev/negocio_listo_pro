import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/bookings/domain/repositories/booking_repository.dart';

class GetBookingsUseCase implements UseCase<List<BookingEntity>, NoParams> {
  final BookingRepository repository;

  const GetBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(NoParams params) {
    return repository.getBookings();
  }
}
