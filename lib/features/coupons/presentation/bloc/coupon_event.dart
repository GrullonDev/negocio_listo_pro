import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';

abstract class CouponEvent {
  const CouponEvent();
}

class LoadCoupons extends CouponEvent {
  const LoadCoupons();
}

class CreateCouponRequested extends CouponEvent {
  final CouponEntity coupon;

  const CreateCouponRequested(this.coupon);
}

class RedeemCouponRequested extends CouponEvent {
  final String code;

  const RedeemCouponRequested(this.code);
}
