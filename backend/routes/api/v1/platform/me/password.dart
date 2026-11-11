import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_auth_service.dart';
import 'package:backend/src/platform/platform_jwt.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.patch) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final jwt = context.read<PlatformJwtPayload>();
  final body = await context.request.json() as Map<String, dynamic>;
  final currentPassword = body['current_password'] as String?;
  final newPassword = body['new_password'] as String?;

  if (currentPassword == null || newPassword == null) {
    return jsonError('current_password y new_password son requeridos');
  }

  if (newPassword.length < 8) {
    return jsonError('La contraseña debe tener al menos 8 caracteres');
  }

  final service = context.read<PlatformAuthService>();
  final ok = await service.changePassword(
    userId: jwt.userId,
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  if (!ok) return jsonUnauthorized('Contraseña actual incorrecta');

  return jsonOk({'message': 'Contraseña actualizada'});
}
