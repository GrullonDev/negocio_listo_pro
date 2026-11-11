import 'dart:io';

import 'package:dotenv/dotenv.dart';

class Env {
  Env._();

  static late final DotEnv _dotenv;

  static void load() {
    _dotenv = DotEnv(includePlatformEnvironment: true);
    final envFile = File('.env');
    if (envFile.existsSync()) {
      _dotenv.load(['.env']);
    }
  }

  static String get databaseHost =>
      _dotenv['DATABASE_HOST'] ?? 'localhost';

  static int get databasePort =>
      int.parse(_dotenv['DATABASE_PORT'] ?? '5432');

  static String get databaseName =>
      _dotenv['DATABASE_NAME'] ?? 'negociolisto_dev';

  static String get databaseUser =>
      _dotenv['DATABASE_USER'] ?? 'negociolisto';

  static String get databasePassword =>
      _dotenv['DATABASE_PASSWORD'] ?? '';

  static String get jwtSecret =>
      _dotenv['JWT_SECRET'] ?? 'dev-secret-change-me';

  static int get jwtAccessExpiryMinutes =>
      int.parse(_dotenv['JWT_ACCESS_EXPIRY_MINUTES'] ?? '15');

  static int get jwtRefreshExpiryDays =>
      int.parse(_dotenv['JWT_REFRESH_EXPIRY_DAYS'] ?? '7');

  static int get port => int.parse(_dotenv['PORT'] ?? '8080');
}
