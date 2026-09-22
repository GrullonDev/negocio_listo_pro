import 'package:isar_community/isar.dart';
import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getCachedSession();
  Future<void> cacheSession(UserModel user);
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Isar isar;

  const AuthLocalDataSourceImpl(this.isar);

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
