import 'package:postgres/postgres.dart';

import 'package:backend/src/auth/password_service.dart';
import 'package:backend/src/database/database.dart';
import 'package:backend/src/platform/platform_jwt.dart';

class PlatformAuthService {
  const PlatformAuthService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, name, email, password_hash, role, is_active, must_change_password
        FROM platform_users
        WHERE LOWER(email) = LOWER(@email)
      '''),
      parameters: {'email': email},
    );

    if (results.isEmpty) return {};

    final row = results.first;
    final isActive = row[5] as bool;
    if (!isActive) return {};

    final storedHash = row[3] as String;
    if (!PasswordService.verify(password, storedHash)) return {};

    final userId = row[0] as String;
    final role = row[4] as String;

    return {
      'user': {
        'id': userId,
        'name': row[1],
        'email': row[2],
        'role': role,
        'must_change_password': row[6],
      },
      'access_token': PlatformJwt.generateAccessToken(userId, role),
    };
  }

  Future<Map<String, dynamic>?> getMe(String userId) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, name, email, role, is_active, must_change_password, created_at
        FROM platform_users WHERE id = @id
      '''),
      parameters: {'id': userId},
    );
    if (results.isEmpty) return null;
    final row = results.first;
    return {
      'id': row[0],
      'name': row[1],
      'email': row[2],
      'role': row[3],
      'is_active': row[4],
      'must_change_password': row[5],
      'created_at': (row[6] as DateTime).toIso8601String(),
    };
  }

  Future<bool> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('SELECT password_hash FROM platform_users WHERE id = @id'),
      parameters: {'id': userId},
    );
    if (results.isEmpty) return false;

    final storedHash = results.first[0] as String;
    if (!PasswordService.verify(currentPassword, storedHash)) return false;

    final newHash = PasswordService.hash(newPassword);
    await Database.pool.execute(
      Sql.named('''
        UPDATE platform_users
        SET password_hash = @hash, must_change_password = false, updated_at = now()
        WHERE id = @id
      '''),
      parameters: {'id': userId, 'hash': newHash},
    );
    return true;
  }
}
