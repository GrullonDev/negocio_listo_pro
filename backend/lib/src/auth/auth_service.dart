import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/auth/password_service.dart';
import 'package:backend/src/database/database.dart';

class AuthService {
  const AuthService();

  static const _uuid = Uuid();

  Future<Map<String, dynamic>> registerBusiness({
    required String businessName,
    required String businessType,
    required String currencyCode,
    required String ownerName,
    required String email,
    required String password,
  }) async {
    final tenantId = _uuid.v4();
    final userId = _uuid.v4();
    final passwordHash = PasswordService.hash(password);

    final results = await Database.pool.execute(
      Sql.named('''
        WITH new_tenant AS (
          INSERT INTO tenants (id, name, business_type, currency_code)
          VALUES (@tenantId, @businessName, @businessType, @currencyCode)
          RETURNING id, name, business_type, currency_code, created_at
        ),
        new_user AS (
          INSERT INTO users (id, tenant_id, name, email, password_hash, role)
          VALUES (@userId, @tenantId, @ownerName, @email, @passwordHash, 'owner')
          RETURNING id, name, email, role, created_at
        )
        SELECT
          new_user.id as user_id,
          new_user.name as user_name,
          new_user.email,
          new_user.role,
          new_tenant.id as tenant_id,
          new_tenant.name as tenant_name,
          new_tenant.business_type,
          new_tenant.currency_code
        FROM new_tenant, new_user
      '''),
      parameters: {
        'tenantId': tenantId,
        'businessName': businessName,
        'businessType': businessType,
        'currencyCode': currencyCode,
        'userId': userId,
        'ownerName': ownerName,
        'email': email,
        'passwordHash': passwordHash,
      },
    );

    final row = results.first;
    final payload = JwtPayload(
      userId: row[0] as String,
      tenantId: row[4] as String,
      role: row[3] as String,
    );

    return {
      'user': {
        'id': row[0],
        'name': row[1],
        'email': row[2],
        'role': row[3],
      },
      'tenant': {
        'id': row[4],
        'name': row[5],
        'business_type': row[6],
        'currency_code': row[7],
      },
      'access_token': JwtService.generateAccessToken(payload),
      'refresh_token': JwtService.generateRefreshToken(payload),
    };
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT u.id, u.name, u.email, u.role, u.password_hash,
               t.id as tenant_id, t.name as tenant_name,
               t.business_type, t.currency_code
        FROM users u
        JOIN tenants t ON t.id = u.tenant_id
        WHERE LOWER(u.email) = LOWER(@email)
      '''),
      parameters: {'email': email},
    );

    if (results.isEmpty) return {};

    final row = results.first;
    final storedHash = row[4] as String;

    if (!PasswordService.verify(password, storedHash)) return {};

    final payload = JwtPayload(
      userId: row[0] as String,
      tenantId: row[5] as String,
      role: row[3] as String,
    );

    return {
      'user': {
        'id': row[0],
        'name': row[1],
        'email': row[2],
        'role': row[3],
      },
      'tenant': {
        'id': row[5],
        'name': row[6],
        'business_type': row[7],
        'currency_code': row[8],
      },
      'access_token': JwtService.generateAccessToken(payload),
      'refresh_token': JwtService.generateRefreshToken(payload),
    };
  }

  Future<Map<String, dynamic>?> getMe({
    required String userId,
    required String tenantId,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT u.id, u.name, u.email, u.role,
               t.id as tenant_id, t.name as tenant_name,
               t.business_type, t.currency_code
        FROM users u
        JOIN tenants t ON t.id = u.tenant_id
        WHERE u.id = @userId AND u.tenant_id = @tenantId
      '''),
      parameters: {'userId': userId, 'tenantId': tenantId},
    );

    if (results.isEmpty) return null;
    final row = results.first;
    return {
      'user': {
        'id': row[0],
        'name': row[1],
        'email': row[2],
        'role': row[3],
      },
      'tenant': {
        'id': row[4],
        'name': row[5],
        'business_type': row[6],
        'currency_code': row[7],
      },
    };
  }
}
