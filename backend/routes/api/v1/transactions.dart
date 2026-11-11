import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/common/request_helpers.dart';
import 'package:backend/src/transactions/transaction_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final jwt = context.read<JwtPayload>();
  final service = context.read<TransactionService>();

  switch (context.request.method) {
    case HttpMethod.get:
      final data = await service.list(tenantId: jwt.tenantId);
      return jsonOk(data);

    case HttpMethod.post:
      try {
        final body = await readJsonBody(context);
        final result = await service.create(
          tenantId: jwt.tenantId,
          description: requireString(body, 'description'),
          amount: requireDouble(body, 'amount'),
          type: requireString(body, 'type'),
          category: body['category'] as String?,
          occurredAt: requireDateTime(body, 'occurred_at'),
          idempotencyKey: body['idempotency_key'] as String?,
        );
        return jsonCreated(result);
      } on FormatException catch (e) {
        return jsonError(e.message);
      }

    default:
      return jsonError('Método no permitido',
          statusCode: HttpStatus.methodNotAllowed);
  }
}
