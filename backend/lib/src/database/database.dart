import 'package:postgres/postgres.dart';

import 'package:backend/src/config/env.dart';

class Database {
  Database._();

  static Pool? _pool;

  static Pool get pool {
    if (_pool == null) {
      throw StateError('Database not initialized. Call Database.init() first.');
    }
    return _pool!;
  }

  static Future<void> init() async {
    _pool = Pool.withEndpoints(
      [
        Endpoint(
          host: Env.databaseHost,
          port: Env.databasePort,
          database: Env.databaseName,
          username: Env.databaseUser,
          password: Env.databasePassword,
        ),
      ],
      settings: const PoolSettings(
        maxConnectionCount: 10,
        sslMode: SslMode.disable,
      ),
    );
    // Verify connectivity.
    await _pool!.execute('SELECT 1');
  }

  static Future<void> close() async {
    await _pool?.close();
    _pool = null;
  }
}
