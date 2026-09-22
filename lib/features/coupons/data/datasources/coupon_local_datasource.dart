import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/coupons/data/models/coupon_model.dart';

abstract class CouponLocalDataSource {
  Future<List<CouponModel>> getCoupons();
  Future<void> createCoupon(CouponModel coupon);
  Future<CouponModel> redeemCoupon(String code);
}

class CouponLocalDataSourceImpl implements CouponLocalDataSource {
  final Isar isar;

  const CouponLocalDataSourceImpl(this.isar);

  @override
  Future<List<CouponModel>> getCoupons() {
    return isar.couponModels.where().sortByExpirationDate().findAll();
  }

  @override
  Future<void> createCoupon(CouponModel coupon) async {
    await isar.writeTxn(() async {
      await isar.couponModels.put(coupon);
    });
  }

  @override
  Future<CouponModel> redeemCoupon(String code) async {
    return isar.writeTxn(() async {
      final coupon = await isar.couponModels
          .filter()
          .codeEqualTo(code, caseSensitive: false)
          .findFirst();

      if (coupon == null) {
        throw const CouponNotFoundFailure();
      }
      if (!coupon.isActive) {
        throw const CouponInactiveFailure();
      }
      if (DateTime.now().isAfter(coupon.expirationDate)) {
        throw const CouponExpiredFailure();
      }
      if (coupon.currentUses >= coupon.maxUses) {
        throw const CouponExhaustedFailure();
      }

      final updatedCoupon = CouponModel()
        ..id = coupon.id
        ..couponId = coupon.couponId
        ..code = coupon.code
        ..discountType = coupon.discountType
        ..value = coupon.value
        ..expirationDate = coupon.expirationDate
        ..maxUses = coupon.maxUses
        ..currentUses = coupon.currentUses + 1
        ..isActive = coupon.isActive;

      await isar.couponModels.put(updatedCoupon);
      return updatedCoupon;
    });
  }
}
