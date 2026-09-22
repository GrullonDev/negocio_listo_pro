import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/coupons/domain/repositories/coupon_repository.dart';

class CreateCouponUseCase implements UseCase<void, CouponEntity> {
  final CouponRepository repository;

  const CreateCouponUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CouponEntity params) {
    return repository.createCoupon(params);
  }
}
