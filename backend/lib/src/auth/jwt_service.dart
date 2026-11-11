import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:backend/src/config/env.dart';

class JwtPayload {
  final String userId;
  final String tenantId;
  final String role;

  const JwtPayload({
    required this.userId,
    required this.tenantId,
    required this.role,
  });
}

class JwtService {
  JwtService._();

  static String generateAccessToken(JwtPayload payload) {
    final jwt = JWT(
      {
        'sub': payload.userId,
        'tid': payload.tenantId,
        'role': payload.role,
      },
      issuer: 'negociolisto-backend',
    );
    return jwt.sign(
      SecretKey(Env.jwtSecret),
      expiresIn: Duration(minutes: Env.jwtAccessExpiryMinutes),
    );
  }

  static String generateRefreshToken(JwtPayload payload) {
    final jwt = JWT(
      {
        'sub': payload.userId,
        'tid': payload.tenantId,
        'role': payload.role,
        'type': 'refresh',
      },
      issuer: 'negociolisto-backend',
    );
    return jwt.sign(
      SecretKey(Env.jwtSecret),
      expiresIn: Duration(days: Env.jwtRefreshExpiryDays),
    );
  }

  static JwtPayload? verifyAccessToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
      final payload = jwt.payload as Map<String, dynamic>;
      if (payload['type'] == 'refresh') return null;
      return JwtPayload(
        userId: payload['sub'] as String,
        tenantId: payload['tid'] as String,
        role: payload['role'] as String,
      );
    } catch (_) {
      return null;
    }
  }
}
