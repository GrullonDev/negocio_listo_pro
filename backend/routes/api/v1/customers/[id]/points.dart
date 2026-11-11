import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/common/request_helpers.dart';
import 'package:backend/src/customers/customer_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final jwt = context.read<JwtPayload>();
  try {
    final body = await readJsonBody(context);
    final result = await context.read<CustomerService>().addPoints(
          tenantId: jwt.tenantId,
          customerId: id,
          pointsDelta: requireInt(body, 'points'),
          reason: requireString(body, 'reason'),
        );
    if (result == null) return jsonNotFound('Cliente no encontrado');
    return jsonOk(result);
  } on FormatException catch (e) {
    return jsonError(e.message);
  }
}
