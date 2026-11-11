import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/session/session_context.dart';
import 'package:negocio_listo_pro/core/sync/sync_repository.dart';
import 'package:negocio_listo_pro/core/sync/sync_service.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';
import 'package:negocio_listo_pro/features/bookings/data/datasources/booking_local_datasource.dart';
import 'package:negocio_listo_pro/features/bookings/data/models/booking_model.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/bookings/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource localDataSource;
  final SyncRepository syncRepository;
  final SyncService syncService;
  final SessionContext sessionContext;

  const BookingRepositoryImpl({
    required this.localDataSource,
    required this.syncRepository,
    required this.syncService,
    required this.sessionContext,
  });

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

      final tenantId = sessionContext.tenantId;
      if (tenantId != null && sessionContext.isRemoteSession) {
        await syncRepository.enqueue(
          tenantId: tenantId,
          entityType: SyncEntityType.booking,
          entityId: booking.id,
          operationType: SyncOperationType.create,
          payload: {
            'client_name': booking.clientName,
            'service': booking.service,
            'date': booking.date.toUtc().toIso8601String(),
          },
        );
        syncService.triggerSync();
      }

      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      await localDataSource.updateStatus(bookingId, status);

      final tenantId = sessionContext.tenantId;
      if (tenantId != null && sessionContext.isRemoteSession) {
        await syncRepository.enqueue(
          tenantId: tenantId,
          entityType: SyncEntityType.booking,
          entityId: bookingId,
          operationType: SyncOperationType.update,
          payload: {'status': status.name},
        );
        syncService.triggerSync();
      }

      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
