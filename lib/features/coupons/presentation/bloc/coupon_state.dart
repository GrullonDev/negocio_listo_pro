import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';

abstract class CouponState {
  const CouponState();
}

class CouponInitial extends CouponState {
  const CouponInitial();
}

class CouponLoading extends CouponState {
  const CouponLoading();
}

class CouponLoaded extends CouponState {
  final List<CouponEntity> coupons;
  final String? redeemMessage;

  const CouponLoaded(this.coupons, {this.redeemMessage});
}

class CouponError extends CouponState {
  final String message;

  const CouponError(this.message);
}
