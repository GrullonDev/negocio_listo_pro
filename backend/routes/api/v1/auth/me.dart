import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/auth_service.dart';
import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/common/json_response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final jwt = context.read<JwtPayload>();
  final result = await context.read<AuthService>().getMe(
        userId: jwt.userId,
        tenantId: jwt.tenantId,
      );

  if (result == null) return jsonNotFound('Usuario no encontrado');
  return jsonOk(result);
}
