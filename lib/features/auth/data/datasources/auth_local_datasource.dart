import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/auth/data/models/credential_model.dart';
import 'package:negocio_listo_pro/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Resolves credentials against the locally stored [CredentialModel]
  /// table. There is no remote server — this is the sole source of truth.
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> getCachedSession();
  Future<void> cacheSession(UserModel user);
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Isar isar;

  const AuthLocalDataSourceImpl(this.isar);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await isar.credentialModels
        .filter()
        .emailEqualTo(email, caseSensitive: false)
        .findFirst();
    if (credential == null ||
        credential.passwordHash != hashPassword(password)) {
      throw const AuthFailure();
    }
    final user = UserModel()
      ..fixedSessionId = UserModel.sessionId
      ..userId = credential.userId
      ..email = credential.email
      ..displayName = credential.displayName
      ..authToken = 'local-${credential.userId}'
      ..tenant = credential.tenant;
    await cacheSession(user);
    return user;
  }

  @override
  Future<UserModel> getCachedSession() async {
    final cached = await isar.userModels
        .filter()
        .fixedSessionIdEqualTo(UserModel.sessionId)
        .findFirst();
    if (cached == null) {
      throw const CacheFailure('No hay una sesión guardada localmente');
    }
    return cached;
  }

  @override
  Future<void> cacheSession(UserModel user) async {
    await isar.writeTxn(() async {
      await isar.userModels.put(user);
    });
  }

  @override
  Future<void> clearSession() async {
    await isar.writeTxn(() async {
      await isar.userModels
          .filter()
          .fixedSessionIdEqualTo(UserModel.sessionId)
          .deleteAll();
    });
  }
}
