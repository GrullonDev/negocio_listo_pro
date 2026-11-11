import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

import 'package:backend/src/database/database.dart';

class TransactionService {
  const TransactionService();

  static const _uuid = Uuid();

  Future<List<Map<String, dynamic>>> list({required String tenantId}) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, description, amount, type, category, occurred_at,
               created_at, updated_at
        FROM transactions
        WHERE tenant_id = @tenantId
        ORDER BY occurred_at DESC
      '''),
      parameters: {'tenantId': tenantId},
    );

    return results.map((row) {
      return {
        'id': row[0],
        'description': row[1],
        'amount': row[2].toString(),
        'type': row[3],
        'category': row[4],
        'occurred_at': (row[5] as DateTime).toIso8601String(),
        'created_at': (row[6] as DateTime).toIso8601String(),
        'updated_at': (row[7] as DateTime).toIso8601String(),
      };
    }).toList();
  }

  Future<Map<String, dynamic>> create({
    required String tenantId,
    required String description,
    required double amount,
    required String type,
    String? category,
    required DateTime occurredAt,
    String? idempotencyKey,
  }) async {
    final id = idempotencyKey ?? _uuid.v4();

    final results = await Database.pool.execute(
      Sql.named('''
        INSERT INTO transactions (id, tenant_id, description, amount, type, category, occurred_at)
        VALUES (@id, @tenantId, @description, @amount, @type, @category, @occurredAt)
        ON CONFLICT (id) DO NOTHING
        RETURNING id, description, amount, type, category, occurred_at, created_at
      '''),
      parameters: {
        'id': id,
        'tenantId': tenantId,
        'description': description,
        'amount': amount,
        'type': type,
        'category': category,
        'occurredAt': occurredAt,
      },
    );

    if (results.isEmpty) {
      return {'id': id, 'status': 'already_exists'};
    }

    final row = results.first;
    return {
      'id': row[0],
      'description': row[1],
      'amount': row[2].toString(),
      'type': row[3],
      'category': row[4],
      'occurred_at': (row[5] as DateTime).toIso8601String(),
      'created_at': (row[6] as DateTime).toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> getSummary({required String tenantId}) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT
          COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) as total_income,
          COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0) as total_expenses,
          COUNT(*) as transaction_count
        FROM transactions
        WHERE tenant_id = @tenantId
      '''),
      parameters: {'tenantId': tenantId},
    );

    final row = results.first;
    final income = double.parse(row[0].toString());
    final expenses = double.parse(row[1].toString());

    return {
      'total_income': row[0].toString(),
      'total_expenses': row[1].toString(),
      'balance': (income - expenses).toStringAsFixed(2),
      'transaction_count': row[2],
    };
  }
}
