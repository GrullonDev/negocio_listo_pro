import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/common/json_response.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final path = context.request.uri.path;

    // Auth endpoints don't require a token.
    if (path.contains('/auth/register-business') ||
        path.contains('/auth/login')) {
      return handler(context);
    }

    final authHeader = context.request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return jsonUnauthorized('Token no proporcionado');
    }

    final token = authHeader.substring(7);
    final payload = JwtService.verifyAccessToken(token);
    if (payload == null) {
      return jsonUnauthorized('Token inválido o expirado');
    }

    return handler(context.provide<JwtPayload>(() => payload));
  };
}
