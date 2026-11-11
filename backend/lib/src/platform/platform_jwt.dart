import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:backend/src/config/env.dart';

class PlatformJwtPayload {
  final String userId;
  final String role;

  const PlatformJwtPayload({required this.userId, required this.role});
}

class PlatformJwt {
  PlatformJwt._();

  static String generateAccessToken(String userId, String role) {
    final jwt = JWT({
      'sub': userId,
      'role': role,
      'scope': 'platform',
    }, issuer: 'negociolisto-backend');
    return jwt.sign(
      SecretKey(Env.jwtSecret),
      expiresIn: Duration(minutes: Env.jwtAccessExpiryMinutes),
    );
  }

  static PlatformJwtPayload? verify(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
      final payload = jwt.payload as Map<String, dynamic>;
      if (payload['scope'] != 'platform') return null;
      return PlatformJwtPayload(
        userId: payload['sub'] as String,
        role: payload['role'] as String,
      );
    } catch (_) {
      return null;
    }
  }
}
