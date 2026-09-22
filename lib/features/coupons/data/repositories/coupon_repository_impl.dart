import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/coupons/data/datasources/coupon_local_datasource.dart';
import 'package:negocio_listo_pro/features/coupons/data/models/coupon_model.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/coupons/domain/repositories/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponLocalDataSource localDataSource;

  const CouponRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CouponEntity>>> getCoupons() async {
    try {
      final coupons = await localDataSource.getCoupons();
      return Right(coupons.map((model) => model.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createCoupon(CouponEntity coupon) async {
    try {
      await localDataSource.createCoupon(CouponModel.fromEntity(coupon));
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CouponEntity>> redeemCoupon(String code) async {
    try {
      final coupon = await localDataSource.redeemCoupon(code);
      return Right(coupon.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
