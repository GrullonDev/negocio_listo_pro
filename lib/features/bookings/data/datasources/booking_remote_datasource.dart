import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/features/bookings/data/models/booking_model.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> addBooking(BookingModel booking);
  Future<BookingModel> updateStatus(String id, BookingStatus status);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  const BookingRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<BookingModel>> getBookings() async {
    final response = await apiClient.get('/api/v1/bookings');
    if (!response.isSuccess) throw Exception(response.errorMessage);

    final list = response.data!['data'] as List? ??
        (response.data is List ? response.data as List : []);
    return list.map((item) {
      final json = item as Map<String, dynamic>;
      return BookingModel()
        ..bookingId = json['id'] as String
        ..clientName = json['client_name'] as String
        ..service = json['service'] as String
        ..date = DateTime.parse(json['date'] as String)
        ..status = BookingStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => BookingStatus.pending,
        );
    }).toList();
  }

  @override
  Future<BookingModel> addBooking(BookingModel booking) async {
    final response = await apiClient.post(
      '/api/v1/bookings',
      body: {
        'client_name': booking.clientName,
        'service': booking.service,
        'date': booking.date.toUtc().toIso8601String(),
      },
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return booking;
  }

  @override
  Future<BookingModel> updateStatus(String id, BookingStatus status) async {
    final response = await apiClient.patch(
      '/api/v1/bookings/$id',
      body: {'status': status.name},
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);

    final json = response.data!;
    return BookingModel()
      ..bookingId = json['id'] as String
      ..clientName = json['client_name'] as String
      ..service = json['service'] as String
      ..date = DateTime.parse(json['date'] as String)
      ..status = BookingStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => BookingStatus.pending,
      );
  }
}
