import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/database/database.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final tenantId = context.read<String>();
  final params = context.request.uri.queryParameters;
  final since = params['since'];
  final entityType = params['entity_type'];
  final limit = int.tryParse(params['limit'] ?? '100') ?? 100;

  if (entityType == null) {
    return jsonError('entity_type is required', statusCode: 400);
  }

  final tables = {
    'transaction': 'transactions',
    'booking': 'bookings',
    'customer': 'customers',
    'coupon': 'coupons',
  };

  final table = tables[entityType];
  if (table == null) {
    return jsonError('Invalid entity_type', statusCode: 400);
  }

  final sinceDate = since != null ? DateTime.tryParse(since) : null;

  final query = sinceDate != null
      ? 'SELECT * FROM $table WHERE tenant_id = @tenantId AND updated_at > @since ORDER BY updated_at ASC LIMIT @limit'
      : 'SELECT * FROM $table WHERE tenant_id = @tenantId ORDER BY updated_at ASC LIMIT @limit';

  final parameters = <String, dynamic>{
    'tenantId': tenantId,
    'limit': limit,
    if (sinceDate != null) 'since': sinceDate,
  };

  final results = await Database.pool.execute(
    Sql.named(query),
    parameters: parameters,
  );

  final rows = results.map((row) {
    final map = <String, dynamic>{};
    for (final col in row.toColumnMap().entries) {
      final value = col.value;
      if (value is DateTime) {
        map[col.key] = value.toIso8601String();
      } else {
        map[col.key] = value;
      }
    }
    return map;
  }).toList();

  return jsonOk({
    'data': rows,
    'count': rows.length,
    'cursor': rows.isNotEmpty ? rows.last['updated_at'] : since,
  });
}
