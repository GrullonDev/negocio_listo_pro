import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/customers/customer_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final jwt = context.read<JwtPayload>();
  final result = await context.read<CustomerService>().getById(
        tenantId: jwt.tenantId,
        customerId: id,
      );
  if (result == null) return jsonNotFound('Cliente no encontrado');
  return jsonOk(result);
}
