import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/bookings/data/datasources/booking_local_datasource.dart';
import 'package:negocio_listo_pro/features/bookings/data/models/booking_model.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/bookings/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource localDataSource;

  const BookingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookings() async {
    try {
      final bookings = await localDataSource.getBookings();
      return Right(bookings.map((model) => model.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addBooking(BookingEntity booking) async {
    try {
      await localDataSource.addBooking(BookingModel.fromEntity(booking));
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
