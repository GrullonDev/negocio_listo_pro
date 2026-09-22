import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/bookings/data/models/booking_model.dart';

abstract class BookingLocalDataSource {
  Future<List<BookingModel>> getBookings();
  Future<void> addBooking(BookingModel booking);
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
}
