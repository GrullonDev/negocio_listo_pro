import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/coupons/domain/repositories/coupon_repository.dart';

class RedeemCouponParams {
  final String code;

  const RedeemCouponParams(this.code);
}

/// Valida vigencia, estado activo y usos disponibles antes de canjear.
/// La regla de negocio se aplica de forma atómica en el datasource local
/// (Isar `writeTxn`), que es la fuente de verdad transaccional.
class RedeemCouponUseCase
    implements UseCase<CouponEntity, RedeemCouponParams> {
  final CouponRepository repository;

  const RedeemCouponUseCase(this.repository);

  @override
  Future<Either<Failure, CouponEntity>> call(RedeemCouponParams params) {
    return repository.redeemCoupon(params.code);
  }
}
