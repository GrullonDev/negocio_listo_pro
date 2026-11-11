import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/bookings/booking_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/common/request_helpers.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.patch) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final jwt = context.read<JwtPayload>();
  try {
    final body = await readJsonBody(context);
    final result = await context.read<BookingService>().updateStatus(
          tenantId: jwt.tenantId,
          bookingId: id,
          status: requireString(body, 'status'),
        );
    if (result == null) return jsonNotFound('Cita no encontrada');
    return jsonOk(result);
  } on FormatException catch (e) {
    return jsonError(e.message);
  }
}
