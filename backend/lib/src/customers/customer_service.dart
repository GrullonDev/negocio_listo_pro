import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

import 'package:backend/src/database/database.dart';

class CustomerService {
  const CustomerService();

  static const _uuid = Uuid();

  Future<List<Map<String, dynamic>>> list({required String tenantId}) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, name, phone, points, tier, created_at, updated_at
        FROM customers
        WHERE tenant_id = @tenantId
        ORDER BY name
      '''),
      parameters: {'tenantId': tenantId},
    );

    return results.map((row) {
      return {
        'id': row[0],
        'name': row[1],
        'phone': row[2],
        'points': row[3],
        'tier': row[4],
        'created_at': (row[5] as DateTime).toIso8601String(),
        'updated_at': (row[6] as DateTime).toIso8601String(),
      };
    }).toList();
  }

  Future<Map<String, dynamic>> create({
    required String tenantId,
    required String name,
    String? phone,
  }) async {
    final id = _uuid.v4();
    final results = await Database.pool.execute(
      Sql.named('''
        INSERT INTO customers (id, tenant_id, name, phone)
        VALUES (@id, @tenantId, @name, @phone)
        RETURNING id, name, phone, points, tier, created_at
      '''),
      parameters: {
        'id': id,
        'tenantId': tenantId,
        'name': name,
        'phone': phone,
      },
    );

    final row = results.first;
    return {
      'id': row[0],
      'name': row[1],
      'phone': row[2],
      'points': row[3],
      'tier': row[4],
      'created_at': (row[5] as DateTime).toIso8601String(),
    };
  }

  Future<Map<String, dynamic>?> getById({
    required String tenantId,
    required String customerId,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, name, phone, points, tier, created_at, updated_at
        FROM customers
        WHERE id = @customerId AND tenant_id = @tenantId
      '''),
      parameters: {'customerId': customerId, 'tenantId': tenantId},
    );

    if (results.isEmpty) return null;
    final row = results.first;
    return {
      'id': row[0],
      'name': row[1],
      'phone': row[2],
      'points': row[3],
      'tier': row[4],
      'created_at': (row[5] as DateTime).toIso8601String(),
      'updated_at': (row[6] as DateTime).toIso8601String(),
    };
  }

  Future<Map<String, dynamic>?> addPoints({
    required String tenantId,
    required String customerId,
    required int pointsDelta,
    required String reason,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('''
        WITH updated AS (
          UPDATE customers
          SET points = points + @pointsDelta,
              tier = CASE
                WHEN points + @pointsDelta >= 1000 THEN 'platinum'
                WHEN points + @pointsDelta >= 500  THEN 'gold'
                WHEN points + @pointsDelta >= 200  THEN 'silver'
                ELSE 'bronze'
              END,
              updated_at = now()
          WHERE id = @customerId AND tenant_id = @tenantId
          RETURNING id, name, points, tier
        ),
        event AS (
          INSERT INTO loyalty_events (tenant_id, customer_id, points_delta, reason)
          SELECT @tenantId, @customerId, @pointsDelta, @reason
          WHERE EXISTS (SELECT 1 FROM updated)
        )
        SELECT id, name, points, tier FROM updated
      '''),
      parameters: {
        'tenantId': tenantId,
        'customerId': customerId,
        'pointsDelta': pointsDelta,
        'reason': reason,
      },
    );

    if (results.isEmpty) return null;
    final row = results.first;
    return {'id': row[0], 'name': row[1], 'points': row[2], 'tier': row[3]};
  }
}
