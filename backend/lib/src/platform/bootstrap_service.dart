import 'dart:math';

import 'package:postgres/postgres.dart';

import 'package:backend/src/auth/password_service.dart';
import 'package:backend/src/config/env.dart';
import 'package:backend/src/database/database.dart';

class BootstrapService {
  const BootstrapService();

  Future<void> run() async {
    if (!Env.bootstrapSuperAdmin) return;

    final existing = await Database.pool.execute(
      Sql.named(
        "SELECT id FROM platform_users WHERE email = @email LIMIT 1",
      ),
      parameters: {'email': Env.superAdminEmail},
    );

    if (existing.isNotEmpty) return;

    final password = Env.superAdminPassword?.isNotEmpty == true
        ? Env.superAdminPassword!
        : _generateSecurePassword(24);

    final mustChange = Env.superAdminPassword?.isNotEmpty != true;
    final hash = PasswordService.hash(password);

    await Database.pool.execute(
      Sql.named('''
        INSERT INTO platform_users (name, email, password_hash, role, must_change_password)
        VALUES (@name, @email, @hash, 'super_admin', @mustChange)
      '''),
      parameters: {
        'name': Env.superAdminName,
        'email': Env.superAdminEmail,
        'hash': hash,
        'mustChange': mustChange,
      },
    );

    if (mustChange) {
      // ignore: avoid_print
      print('');
      // ignore: avoid_print
      print('╔══════════════════════════════════════════════════════════╗');
      // ignore: avoid_print
      print('║  SUPER ADMIN CREATED (temporary credentials)           ║');
      // ignore: avoid_print
      print('║  Email:    ${Env.superAdminEmail.padRight(43)}║');
      // ignore: avoid_print
      print('║  Password: ${password.padRight(43)}║');
      // ignore: avoid_print
      print('║  ⚠  Change this password on first login.               ║');
      // ignore: avoid_print
      print('╚══════════════════════════════════════════════════════════╝');
      // ignore: avoid_print
      print('');
    } else {
      // ignore: avoid_print
      print('Super admin created: ${Env.superAdminEmail}');
    }
  }

  static String _generateSecurePassword(int length) {
    const chars =
        'abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#\$%&*';
    final rng = Random.secure();
    return List.generate(length, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
