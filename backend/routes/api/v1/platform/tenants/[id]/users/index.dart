import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_jwt.dart';
import 'package:backend/src/platform/platform_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final jwt = context.read<PlatformJwtPayload>();
  final service = context.read<PlatformService>();

  if (context.request.method == HttpMethod.get) {
    final users = await service.listTenantUsers(id);
    return jsonOk(users);
  }

  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json() as Map<String, dynamic>;
    final name = body['name'] as String?;
    final email = body['email'] as String?;
    final role = body['role'] as String? ?? 'staff';

    if (name == null || email == null) {
      return jsonError('name y email son requeridos');
    }

    if (role != 'owner' && role != 'staff') {
      return jsonError('role debe ser owner o staff');
    }

    final result = await service.createTenantUser(
      tenantId: id,
      name: name,
      email: email,
      role: role,
      actorId: jwt.userId,
    );
    return jsonCreated(result);
  }

  return jsonError('Método no permitido',
      statusCode: HttpStatus.methodNotAllowed);
}
