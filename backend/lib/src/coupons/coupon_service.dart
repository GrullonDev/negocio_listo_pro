import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

import 'package:backend/src/database/database.dart';

class CouponService {
  const CouponService();

  static const _uuid = Uuid();

  Future<List<Map<String, dynamic>>> list({required String tenantId}) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, code, discount_type, value, max_uses, current_uses,
               expiration_date, is_active, created_at, updated_at
        FROM coupons
        WHERE tenant_id = @tenantId
        ORDER BY created_at DESC
      '''),
      parameters: {'tenantId': tenantId},
    );

    return results.map((row) {
      return {
        'id': row[0],
        'code': row[1],
        'discount_type': row[2],
        'value': row[3].toString(),
        'max_uses': row[4],
        'current_uses': row[5],
        'expiration_date': (row[6] as DateTime).toIso8601String(),
        'is_active': row[7],
        'created_at': (row[8] as DateTime).toIso8601String(),
        'updated_at': (row[9] as DateTime).toIso8601String(),
      };
    }).toList();
  }

  Future<Map<String, dynamic>> create({
    required String tenantId,
    required String code,
    required String discountType,
    required double value,
    required int maxUses,
    required DateTime expirationDate,
  }) async {
    final id = _uuid.v4();
    final results = await Database.pool.execute(
      Sql.named('''
        INSERT INTO coupons (id, tenant_id, code, discount_type, value, max_uses, expiration_date)
        VALUES (@id, @tenantId, @code, @discountType, @value, @maxUses, @expirationDate)
        RETURNING id, code, discount_type, value, max_uses, current_uses,
                  expiration_date, is_active, created_at
      '''),
      parameters: {
        'id': id,
        'tenantId': tenantId,
        'code': code,
        'discountType': discountType,
        'value': value,
        'maxUses': maxUses,
        'expirationDate': expirationDate,
      },
    );

    final row = results.first;
    return {
      'id': row[0],
      'code': row[1],
      'discount_type': row[2],
      'value': row[3].toString(),
      'max_uses': row[4],
      'current_uses': row[5],
      'expiration_date': (row[6] as DateTime).toIso8601String(),
      'is_active': row[7],
      'created_at': (row[8] as DateTime).toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> redeem({
    required String tenantId,
    required String code,
    required String idempotencyKey,
    String? customerId,
  }) async {
    // Check idempotency first.
    final existing = await Database.pool.execute(
      Sql.named('''
        SELECT coupon_id FROM coupon_redemptions
        WHERE idempotency_key = @key
      '''),
      parameters: {'key': idempotencyKey},
    );
    if (existing.isNotEmpty) {
      return {'status': 'already_redeemed', 'coupon_id': existing.first[0]};
    }

    final results = await Database.pool.execute(
      Sql.named('''
        WITH target AS (
          SELECT id, code, is_active, expiration_date, max_uses, current_uses
          FROM coupons
          WHERE tenant_id = @tenantId AND LOWER(code) = LOWER(@code)
          FOR UPDATE
        ),
        validated AS (
          SELECT id FROM target
          WHERE is_active = true
            AND expiration_date > now()
            AND current_uses < max_uses
        ),
        updated AS (
          UPDATE coupons
          SET current_uses = current_uses + 1, updated_at = now()
          WHERE id = (SELECT id FROM validated)
          RETURNING id, code, current_uses, max_uses
        ),
        redemption AS (
          INSERT INTO coupon_redemptions (tenant_id, coupon_id, customer_id, idempotency_key)
          SELECT @tenantId, id, @customerId, @idempotencyKey
          FROM updated
        )
        SELECT u.id, u.code, u.current_uses, u.max_uses,
               t.is_active, t.expiration_date
        FROM target t
        LEFT JOIN updated u ON u.id = t.id
      '''),
      parameters: {
        'tenantId': tenantId,
        'code': code,
        'customerId': customerId,
        'idempotencyKey': idempotencyKey,
      },
    );

    if (results.isEmpty) {
      return {'status': 'not_found'};
    }

    final row = results.first;
    if (row[0] == null) {
      // target found but validation failed
      final isActive = row[4] as bool;
      final expDate = row[5] as DateTime;
      if (!isActive) return {'status': 'inactive'};
      if (expDate.isBefore(DateTime.now())) return {'status': 'expired'};
      return {'status': 'exhausted'};
    }

    return {
      'status': 'redeemed',
      'coupon': {
        'id': row[0],
        'code': row[1],
        'current_uses': row[2],
        'max_uses': row[3],
      },
    };
  }
}
