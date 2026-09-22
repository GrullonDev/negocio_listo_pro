import 'package:dartz/dartz.dart';
import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/network/network_info.dart';
import 'package:negocio_listo_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:negocio_listo_pro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:negocio_listo_pro/features/auth/domain/entities/user_entity.dart';
import 'package:negocio_listo_pro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.cacheSession(userModel);
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
