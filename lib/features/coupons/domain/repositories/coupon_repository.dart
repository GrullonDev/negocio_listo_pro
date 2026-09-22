import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';

/// Contrato de persistencia y validación de cupones, resuelto
/// íntegramente de forma local con Isar — sin llamadas remotas.
abstract class CouponRepository {
  Future<Either<Failure, List<CouponEntity>>> getCoupons();
  Future<Either<Failure, void>> createCoupon(CouponEntity coupon);
  Future<Either<Failure, CouponEntity>> redeemCoupon(String code);
}
