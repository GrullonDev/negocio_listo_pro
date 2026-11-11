import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_jwt.dart';
import 'package:backend/src/platform/platform_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final jwt = context.read<PlatformJwtPayload>();
  final service = context.read<PlatformService>();

  if (context.request.method == HttpMethod.get) {
    final tenant = await service.getTenant(id);
    if (tenant == null) return jsonNotFound('Negocio no encontrado');
    return jsonOk(tenant);
  }

  if (context.request.method == HttpMethod.patch) {
    final body = await context.request.json() as Map<String, dynamic>;
    await service.updateTenant(
      id: id,
      name: body['name'] as String?,
      status: body['status'] as String?,
      brandId: body['brand_id'] as String?,
      actorId: jwt.userId,
    );
    return jsonOk({'message': 'Negocio actualizado'});
  }

  return jsonError('Método no permitido',
      statusCode: HttpStatus.methodNotAllowed);
}
