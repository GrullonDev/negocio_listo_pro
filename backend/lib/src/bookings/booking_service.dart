import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

import 'package:backend/src/database/database.dart';

class BookingService {
  const BookingService();

  static const _uuid = Uuid();

  Future<List<Map<String, dynamic>>> list({required String tenantId}) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, customer_id, client_name, service, start_at, end_at,
               status, created_at, updated_at
        FROM bookings
        WHERE tenant_id = @tenantId
        ORDER BY start_at DESC
      '''),
      parameters: {'tenantId': tenantId},
    );

    return results.map((row) {
      return {
        'id': row[0],
        'customer_id': row[1],
        'client_name': row[2],
        'service': row[3],
        'start_at': (row[4] as DateTime).toIso8601String(),
        'end_at': row[5] != null
            ? (row[5] as DateTime).toIso8601String()
            : null,
        'status': row[6],
        'created_at': (row[7] as DateTime).toIso8601String(),
        'updated_at': (row[8] as DateTime).toIso8601String(),
      };
    }).toList();
  }

  Future<Map<String, dynamic>> create({
    required String tenantId,
    required String clientName,
    required String service,
    required DateTime startAt,
    DateTime? endAt,
    String? customerId,
  }) async {
    final id = _uuid.v4();
    final results = await Database.pool.execute(
      Sql.named('''
        INSERT INTO bookings (id, tenant_id, customer_id, client_name, service, start_at, end_at)
        VALUES (@id, @tenantId, @customerId, @clientName, @service, @startAt, @endAt)
        RETURNING id, client_name, service, start_at, end_at, status, created_at
      '''),
      parameters: {
        'id': id,
        'tenantId': tenantId,
        'customerId': customerId,
        'clientName': clientName,
        'service': service,
        'startAt': startAt,
        'endAt': endAt,
      },
    );

    final row = results.first;
    return {
      'id': row[0],
      'client_name': row[1],
      'service': row[2],
      'start_at': (row[3] as DateTime).toIso8601String(),
      'end_at': row[4] != null ? (row[4] as DateTime).toIso8601String() : null,
      'status': row[5],
      'created_at': (row[6] as DateTime).toIso8601String(),
    };
  }

  Future<Map<String, dynamic>?> updateStatus({
    required String tenantId,
    required String bookingId,
    required String status,
  }) async {
    const allowed = ['pending', 'confirmed', 'completed', 'cancelled'];
    if (!allowed.contains(status)) return null;

    final results = await Database.pool.execute(
      Sql.named('''
        UPDATE bookings
        SET status = @status, updated_at = now()
        WHERE id = @bookingId AND tenant_id = @tenantId
        RETURNING id, client_name, service, start_at, end_at, status, updated_at
      '''),
      parameters: {
        'bookingId': bookingId,
        'tenantId': tenantId,
        'status': status,
      },
    );

    if (results.isEmpty) return null;
    final row = results.first;
    return {
      'id': row[0],
      'client_name': row[1],
      'service': row[2],
      'start_at': (row[3] as DateTime).toIso8601String(),
      'end_at': row[4] != null ? (row[4] as DateTime).toIso8601String() : null,
      'status': row[5],
      'updated_at': (row[6] as DateTime).toIso8601String(),
    };
  }
}
