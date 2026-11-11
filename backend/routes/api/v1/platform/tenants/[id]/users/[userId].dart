import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_jwt.dart';
import 'package:backend/src/platform/platform_service.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
  String userId,
) async {
  if (context.request.method != HttpMethod.patch) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final jwt = context.read<PlatformJwtPayload>();
  final service = context.read<PlatformService>();
  final body = await context.request.json() as Map<String, dynamic>;

  final ok = await service.updateTenantUser(
    tenantId: id,
    userId: userId,
    name: body['name'] as String?,
    role: body['role'] as String?,
    resetPassword: body['reset_password'] as bool?,
    actorId: jwt.userId,
  );

  if (!ok) return jsonError('No se realizaron cambios');
  return jsonOk({'message': 'Usuario actualizado'});
}
