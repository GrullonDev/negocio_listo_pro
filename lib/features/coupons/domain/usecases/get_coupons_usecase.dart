import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/coupons/domain/repositories/coupon_repository.dart';

class GetCouponsUseCase implements UseCase<List<CouponEntity>, NoParams> {
  final CouponRepository repository;

  const GetCouponsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CouponEntity>>> call(NoParams params) {
    return repository.getCoupons();
  }
}
