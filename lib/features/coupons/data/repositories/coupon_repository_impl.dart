import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/session/session_context.dart';
import 'package:negocio_listo_pro/core/sync/sync_repository.dart';
import 'package:negocio_listo_pro/core/sync/sync_service.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';
import 'package:negocio_listo_pro/features/coupons/data/datasources/coupon_local_datasource.dart';
import 'package:negocio_listo_pro/features/coupons/data/models/coupon_model.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/coupons/domain/repositories/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponLocalDataSource localDataSource;
  final SyncRepository syncRepository;
  final SyncService syncService;
  final SessionContext sessionContext;

  const CouponRepositoryImpl({
    required this.localDataSource,
    required this.syncRepository,
    required this.syncService,
    required this.sessionContext,
  });

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

      final tenantId = sessionContext.tenantId;
      if (tenantId != null && sessionContext.isRemoteSession) {
        await syncRepository.enqueue(
          tenantId: tenantId,
          entityType: SyncEntityType.coupon,
          entityId: coupon.id,
          operationType: SyncOperationType.create,
          payload: {
            'code': coupon.code,
            'discount_type': coupon.discountType.name,
            'value': coupon.value,
            'expiration_date':
                coupon.expirationDate.toUtc().toIso8601String(),
            'max_uses': coupon.maxUses,
          },
        );
        syncService.triggerSync();
      }

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

      final tenantId = sessionContext.tenantId;
      if (tenantId != null && sessionContext.isRemoteSession) {
        await syncRepository.enqueue(
          tenantId: tenantId,
          entityType: SyncEntityType.coupon,
          entityId: coupon.couponId,
          operationType: SyncOperationType.update,
          payload: {'code': code},
        );
        syncService.triggerSync();
      }

      return Right(coupon.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
