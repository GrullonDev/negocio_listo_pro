import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_auth_service.dart';
import 'package:backend/src/platform/platform_jwt.dart';

Future<Response> onRequest(RequestContext context) async {
  final jwt = context.read<PlatformJwtPayload>();

  if (context.request.method == HttpMethod.get) {
    final service = context.read<PlatformAuthService>();
    final user = await service.getMe(jwt.userId);
    if (user == null) return jsonNotFound('Usuario no encontrado');
    return jsonOk(user);
  }

  return jsonError('Método no permitido',
      statusCode: HttpStatus.methodNotAllowed);
}
