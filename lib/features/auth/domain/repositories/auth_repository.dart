import 'package:dartz/dartz.dart';
import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Authenticates against the backend and persists the resulting
  /// session locally. Requires connectivity — login cannot be resolved
  /// from cache since credentials must be verified server-side.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Offline-first: always resolves from local cache first. Returns
  /// [CacheFailure] when no session has been persisted yet.
  Future<Either<Failure, UserEntity>> getCurrentSession();

  /// Clears the locally persisted session.
  Future<Either<Failure, void>> logout();
}
