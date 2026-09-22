enum BookingStatus { pending, confirmed, completed, cancelled }

class BookingEntity {
  final String id;
  final String clientName;
  final String service;
  final DateTime date;
  final BookingStatus status;

  const BookingEntity({
    required this.id,
    required this.clientName,
    required this.service,
    required this.date,
    required this.status,
  });

  BookingEntity copyWith({BookingStatus? status}) {
    return BookingEntity(
      id: id,
      clientName: clientName,
      service: service,
      date: date,
      status: status ?? this.status,
    );
  }
}
