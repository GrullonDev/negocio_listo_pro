import 'dart:math';

import 'package:postgres/postgres.dart';

import 'package:backend/src/auth/password_service.dart';
import 'package:backend/src/database/database.dart';

class PlatformService {
  const PlatformService();

  // ── Dashboard ──

  Future<Map<String, dynamic>> getDashboard() async {
    final tenantCount = await Database.pool.execute(
      Sql.named('SELECT count(*) FROM tenants'),
    );
    final activeCount = await Database.pool.execute(
      Sql.named("SELECT count(*) FROM tenants WHERE status = 'active'"),
    );
    final userCount = await Database.pool.execute(
      Sql.named('SELECT count(*) FROM users'),
    );
    final brandCount = await Database.pool.execute(
      Sql.named('SELECT count(*) FROM brands'),
    );
    final recentLogs = await Database.pool.execute(
      Sql.named('''
        SELECT al.id, al.action, al.target_type, al.target_id, al.created_at,
               pu.name as actor_name
        FROM platform_audit_logs al
        JOIN platform_users pu ON pu.id = al.actor_id
        ORDER BY al.created_at DESC LIMIT 10
      '''),
    );

    return {
      'total_tenants': tenantCount.first[0],
      'active_tenants': activeCount.first[0],
      'total_users': userCount.first[0],
      'total_brands': brandCount.first[0],
      'recent_activity': recentLogs.map((r) => {
        'id': r[0],
        'action': r[1],
        'target_type': r[2],
        'target_id': r[3],
        'created_at': (r[4] as DateTime).toIso8601String(),
        'actor_name': r[5],
      }).toList(),
    };
  }

  // ── Tenants ──

  Future<List<Map<String, dynamic>>> listTenants({
    int limit = 25,
    int offset = 0,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT t.id, t.name, t.business_type, t.currency_code, t.status,
               t.created_at, t.updated_at, b.display_name as brand_name
        FROM tenants t
        LEFT JOIN brands b ON b.id = t.brand_id
        ORDER BY t.created_at DESC
        LIMIT @limit OFFSET @offset
      '''),
      parameters: {'limit': limit, 'offset': offset},
    );
    return results
        .map((r) => {
              'id': r[0],
              'name': r[1],
              'business_type': r[2],
              'currency_code': r[3],
              'status': r[4],
              'created_at': (r[5] as DateTime).toIso8601String(),
              'updated_at': (r[6] as DateTime).toIso8601String(),
              'brand_name': r[7],
            })
        .toList();
  }

  Future<Map<String, dynamic>?> getTenant(String id) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT t.id, t.name, t.business_type, t.currency_code, t.status,
               t.brand_id, t.created_at, t.updated_at,
               b.display_name as brand_name, b.brand_key
        FROM tenants t
        LEFT JOIN brands b ON b.id = t.brand_id
        WHERE t.id = @id
      '''),
      parameters: {'id': id},
    );
    if (results.isEmpty) return null;
    final r = results.first;
    return {
      'id': r[0],
      'name': r[1],
      'business_type': r[2],
      'currency_code': r[3],
      'status': r[4],
      'brand_id': r[5],
      'created_at': (r[6] as DateTime).toIso8601String(),
      'updated_at': (r[7] as DateTime).toIso8601String(),
      'brand_name': r[8],
      'brand_key': r[9],
    };
  }

  Future<Map<String, dynamic>> createTenant({
    required String name,
    required String businessType,
    required String currencyCode,
    String? brandId,
    required String ownerName,
    required String ownerEmail,
    required String actorId,
  }) async {
    final tempPassword = _generateSecurePassword(16);
    final passwordHash = PasswordService.hash(tempPassword);

    final results = await Database.pool.execute(
      Sql.named('''
        WITH new_tenant AS (
          INSERT INTO tenants (name, business_type, currency_code, brand_id, status, created_by)
          VALUES (@name, @businessType, @currencyCode,
                  ${brandId != null ? '@brandId' : 'NULL'},
                  'active', @actorId)
          RETURNING id
        ),
        new_user AS (
          INSERT INTO users (tenant_id, name, email, password_hash, role)
          VALUES ((SELECT id FROM new_tenant), @ownerName, @ownerEmail, @hash, 'owner')
          RETURNING id, name, email
        ),
        audit AS (
          INSERT INTO platform_audit_logs (actor_id, action, target_type, target_id, metadata)
          VALUES (@actorId, 'create_tenant', 'tenant',
                  (SELECT id::text FROM new_tenant),
                  jsonb_build_object('name', @name, 'owner_email', @ownerEmail))
        )
        SELECT new_tenant.id as tenant_id, new_user.id as user_id,
               new_user.name as user_name, new_user.email
        FROM new_tenant, new_user
      '''),
      parameters: {
        'name': name,
        'businessType': businessType,
        'currencyCode': currencyCode,
        if (brandId != null) 'brandId': brandId,
        'ownerName': ownerName,
        'ownerEmail': ownerEmail,
        'hash': passwordHash,
        'actorId': actorId,
      },
    );

    final row = results.first;
    return {
      'tenant_id': row[0],
      'owner': {
        'id': row[1],
        'name': row[2],
        'email': row[3],
        'temporary_password': tempPassword,
      },
    };
  }

  Future<bool> updateTenant({
    required String id,
    String? name,
    String? status,
    String? brandId,
    required String actorId,
  }) async {
    final sets = <String>[];
    final params = <String, Object?>{'id': id, 'actorId': actorId};

    if (name != null) {
      sets.add('name = @name');
      params['name'] = name;
    }
    if (status != null) {
      sets.add('status = @status');
      params['status'] = status;
    }
    if (brandId != null) {
      sets.add('brand_id = @brandId');
      params['brandId'] = brandId;
    }
    if (sets.isEmpty) return false;

    sets.add('updated_at = now()');

    await Database.pool.execute(
      Sql.named('UPDATE tenants SET ${sets.join(', ')} WHERE id = @id'),
      parameters: params,
    );

    await _audit(actorId, 'update_tenant', 'tenant', id,
        metadata: {'fields': sets.map((s) => s.split(' = ').first).toList()});

    return true;
  }

  // ── Brands ──

  Future<List<Map<String, dynamic>>> listBrands() async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, brand_key, display_name, tagline, primary_color,
               secondary_color, background_color, currency_code, currency_symbol,
               is_active, created_at
        FROM brands ORDER BY brand_key
      '''),
    );
    return results
        .map((r) => {
              'id': r[0],
              'brand_key': r[1],
              'display_name': r[2],
              'tagline': r[3],
              'primary_color': r[4],
              'secondary_color': r[5],
              'background_color': r[6],
              'currency_code': r[7],
              'currency_symbol': r[8],
              'is_active': r[9],
              'created_at': (r[10] as DateTime).toIso8601String(),
            })
        .toList();
  }

  Future<Map<String, dynamic>> createBrand({
    required String brandKey,
    required String displayName,
    String tagline = '',
    String primaryColor = '#00236F',
    String secondaryColor = '#006C49',
    String backgroundColor = '#FFFFFF',
    String currencyCode = 'GTQ',
    String currencySymbol = 'Q',
    required String actorId,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('''
        INSERT INTO brands (brand_key, display_name, tagline, primary_color,
          secondary_color, background_color, currency_code, currency_symbol)
        VALUES (@key, @name, @tagline, @primary, @secondary, @bg, @cc, @cs)
        RETURNING id, brand_key, display_name
      '''),
      parameters: {
        'key': brandKey,
        'name': displayName,
        'tagline': tagline,
        'primary': primaryColor,
        'secondary': secondaryColor,
        'bg': backgroundColor,
        'cc': currencyCode,
        'cs': currencySymbol,
      },
    );

    final row = results.first;
    await _audit(actorId, 'create_brand', 'brand', row[0] as String);

    return {'id': row[0], 'brand_key': row[1], 'display_name': row[2]};
  }

  Future<bool> updateBrand({
    required String id,
    Map<String, dynamic> fields = const {},
    required String actorId,
  }) async {
    final allowed = {
      'display_name',
      'tagline',
      'primary_color',
      'secondary_color',
      'background_color',
      'currency_code',
      'currency_symbol',
      'is_active',
    };
    final sets = <String>[];
    final params = <String, Object?>{'id': id, 'actorId': actorId};

    for (final entry in fields.entries) {
      if (!allowed.contains(entry.key)) continue;
      sets.add('${entry.key} = @${entry.key}');
      params[entry.key] = entry.value;
    }
    if (sets.isEmpty) return false;
    sets.add('updated_at = now()');

    await Database.pool.execute(
      Sql.named('UPDATE brands SET ${sets.join(', ')} WHERE id = @id'),
      parameters: params,
    );
    await _audit(actorId, 'update_brand', 'brand', id);
    return true;
  }

  // ── Tenant Users ──

  Future<List<Map<String, dynamic>>> listTenantUsers(String tenantId) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT id, name, email, role, created_at, updated_at
        FROM users WHERE tenant_id = @tid ORDER BY created_at
      '''),
      parameters: {'tid': tenantId},
    );
    return results
        .map((r) => {
              'id': r[0],
              'name': r[1],
              'email': r[2],
              'role': r[3],
              'created_at': (r[4] as DateTime).toIso8601String(),
              'updated_at': (r[5] as DateTime).toIso8601String(),
            })
        .toList();
  }

  Future<Map<String, dynamic>> createTenantUser({
    required String tenantId,
    required String name,
    required String email,
    required String role,
    required String actorId,
  }) async {
    final tempPassword = _generateSecurePassword(16);
    final hash = PasswordService.hash(tempPassword);

    final results = await Database.pool.execute(
      Sql.named('''
        INSERT INTO users (tenant_id, name, email, password_hash, role)
        VALUES (@tid, @name, @email, @hash, @role)
        RETURNING id, name, email, role
      '''),
      parameters: {
        'tid': tenantId,
        'name': name,
        'email': email,
        'hash': hash,
        'role': role,
      },
    );

    final row = results.first;
    await _audit(actorId, 'create_tenant_user', 'user', row[0] as String,
        metadata: {'tenant_id': tenantId});

    return {
      'id': row[0],
      'name': row[1],
      'email': row[2],
      'role': row[3],
      'temporary_password': tempPassword,
    };
  }

  Future<bool> updateTenantUser({
    required String tenantId,
    required String userId,
    String? name,
    String? role,
    bool? resetPassword,
    required String actorId,
  }) async {
    final sets = <String>[];
    final params = <String, Object?>{
      'uid': userId,
      'tid': tenantId,
      'actorId': actorId,
    };

    if (name != null) {
      sets.add('name = @name');
      params['name'] = name;
    }
    if (role != null) {
      sets.add('role = @role');
      params['role'] = role;
    }
    if (sets.isEmpty && resetPassword != true) return false;

    if (resetPassword == true) {
      final tempPassword = _generateSecurePassword(16);
      sets.add('password_hash = @hash');
      params['hash'] = PasswordService.hash(tempPassword);
      params['tempPassword'] = tempPassword;
    }

    sets.add('updated_at = now()');

    await Database.pool.execute(
      Sql.named(
        'UPDATE users SET ${sets.join(', ')} WHERE id = @uid AND tenant_id = @tid',
      ),
      parameters: params,
    );

    await _audit(actorId, 'update_tenant_user', 'user', userId,
        metadata: {'tenant_id': tenantId});

    return true;
  }

  // ── Audit logs ──

  Future<List<Map<String, dynamic>>> listAuditLogs({
    int limit = 50,
    int offset = 0,
  }) async {
    final results = await Database.pool.execute(
      Sql.named('''
        SELECT al.id, al.action, al.target_type, al.target_id,
               al.metadata, al.created_at, pu.name as actor_name
        FROM platform_audit_logs al
        JOIN platform_users pu ON pu.id = al.actor_id
        ORDER BY al.created_at DESC
        LIMIT @limit OFFSET @offset
      '''),
      parameters: {'limit': limit, 'offset': offset},
    );
    return results
        .map((r) => {
              'id': r[0],
              'action': r[1],
              'target_type': r[2],
              'target_id': r[3],
              'metadata': r[4],
              'created_at': (r[5] as DateTime).toIso8601String(),
              'actor_name': r[6],
            })
        .toList();
  }

  Future<void> _audit(
    String actorId,
    String action,
    String targetType,
    String? targetId, {
    Map<String, dynamic>? metadata,
  }) async {
    await Database.pool.execute(
      Sql.named('''
        INSERT INTO platform_audit_logs (actor_id, action, target_type, target_id, metadata)
        VALUES (@actorId, @action, @targetType, @targetId,
                ${metadata != null ? '@metadata::jsonb' : 'NULL'})
      '''),
      parameters: {
        'actorId': actorId,
        'action': action,
        'targetType': targetType,
        'targetId': targetId,
        if (metadata != null) 'metadata': metadata.toString(),
      },
    );
  }

  static String _generateSecurePassword(int length) {
    const chars =
        'abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#\$%&*';
    final rng = Random.secure();
    return List.generate(length, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
