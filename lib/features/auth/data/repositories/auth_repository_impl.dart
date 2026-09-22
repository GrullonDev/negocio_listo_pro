import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:negocio_listo_pro/features/auth/domain/entities/user_entity.dart';
import 'package:negocio_listo_pro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await localDataSource.login(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentSession() async {
    try {
      final cached = await localDataSource.getCachedSession();
      return Right(cached.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearSession();
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
