import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/loyalty/data/datasources/loyalty_local_datasource.dart';
import 'package:negocio_listo_pro/features/loyalty/data/models/customer_model.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/repositories/loyalty_repository.dart';

class LoyaltyRepositoryImpl implements LoyaltyRepository {
  final LoyaltyLocalDataSource localDataSource;

  const LoyaltyRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CustomerLoyaltyEntity>>> getCustomers() async {
    try {
      final customers = await localDataSource.getCustomers();
      return Right(customers.map((model) => model.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addCustomer(
    CustomerLoyaltyEntity customer,
  ) async {
    try {
      await localDataSource.addCustomer(CustomerModel.fromEntity(customer));
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addPoints(String customerId, int points) async {
    try {
      await localDataSource.addPoints(customerId, points);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
