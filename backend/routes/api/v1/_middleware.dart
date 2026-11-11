
import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_jwt.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final path = context.request.uri.path;

    // Auth endpoints don't require a token.
    if (path.contains('/auth/register-business') ||
        path.contains('/auth/login') ||
        path.contains('/platform/auth/login')) {
      return handler(context);
    }

    final authHeader = context.request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return jsonUnauthorized('Token no proporcionado');
    }

    final token = authHeader.substring(7);

    // Platform routes use platform JWT (no tenantId)
    if (path.contains('/platform/')) {
      final platformPayload = PlatformJwt.verify(token);
      if (platformPayload == null) {
        return jsonUnauthorized('Token de plataforma inválido o expirado');
      }
      if (platformPayload.role != 'super_admin') {
        return jsonForbidden('Acceso denegado: se requiere super_admin');
      }
      return handler(
        context.provide<PlatformJwtPayload>(() => platformPayload),
      );
    }

    // Tenant routes use tenant JWT
    final payload = JwtService.verifyAccessToken(token);
    if (payload == null) {
      return jsonUnauthorized('Token inválido o expirado');
    }

    return handler(context.provide<JwtPayload>(() => payload));
  };
}
