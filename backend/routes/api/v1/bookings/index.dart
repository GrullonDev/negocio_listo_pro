import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/bookings/booking_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/common/request_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  final jwt = context.read<JwtPayload>();
  final service = context.read<BookingService>();

  switch (context.request.method) {
    case HttpMethod.get:
      final data = await service.list(tenantId: jwt.tenantId);
      return jsonOk(data);

    case HttpMethod.post:
      try {
        final body = await readJsonBody(context);
        final result = await service.create(
          tenantId: jwt.tenantId,
          clientName: requireString(body, 'client_name'),
          service: requireString(body, 'service'),
          startAt: requireDateTime(body, 'start_at'),
          endAt: body['end_at'] != null
              ? DateTime.parse(body['end_at'] as String)
              : null,
          customerId: body['customer_id'] as String?,
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
