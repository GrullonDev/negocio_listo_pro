import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (email == null || password == null) {
    return jsonError('email y password son requeridos');
  }

  final service = context.read<PlatformAuthService>();
  final result = await service.login(email: email, password: password);

  if (result.isEmpty) {
    return jsonUnauthorized('Credenciales inválidas');
  }

  return jsonOk(result);
}
