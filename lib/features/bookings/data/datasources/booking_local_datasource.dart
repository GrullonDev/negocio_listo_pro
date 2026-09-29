import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/bookings/data/models/booking_model.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';

abstract class BookingLocalDataSource {
  Future<List<BookingModel>> getBookings();
  Future<void> addBooking(BookingModel booking);
  Future<void> updateStatus(String bookingId, BookingStatus status);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  final Isar isar;

  const BookingLocalDataSourceImpl(this.isar);

  @override
  Future<List<BookingModel>> getBookings() {
    return isar.bookingModels.where().sortByDate().findAll();
  }

  @override
  Future<void> addBooking(BookingModel booking) async {
    await isar.writeTxn(() async {
      await isar.bookingModels.put(booking);
    });
  }

  @override
  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    await isar.writeTxn(() async {
      final booking = await isar.bookingModels
          .filter()
          .bookingIdEqualTo(bookingId)
          .findFirst();
      if (booking == null) {
        throw const CacheFailure('Cita no encontrada');
      }
      booking.status = status;
      await isar.bookingModels.put(booking);
    });
  }
}
