import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';

part 'booking_model.g.dart';

@collection
class BookingModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String bookingId;

  late String clientName;
  late String service;
  late DateTime date;

  @enumerated
  late BookingStatus status;

  BookingModel();

  BookingEntity toEntity() {
    return BookingEntity(
      id: bookingId,
      clientName: clientName,
      service: service,
      date: date,
      status: status,
    );
  }

  static BookingModel fromEntity(BookingEntity entity) {
    return BookingModel()
      ..bookingId = entity.id
      ..clientName = entity.clientName
      ..service = entity.service
      ..date = entity.date
      ..status = entity.status;
  }
}
