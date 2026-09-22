import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';

part 'coupon_model.g.dart';

@collection
class CouponModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String couponId;

  @Index(unique: true, caseSensitive: false)
  late String code;

  @enumerated
  late DiscountType discountType;

  late double value;
  late DateTime expirationDate;
  late int maxUses;
  late int currentUses;
  late bool isActive;

  CouponModel();

  CouponEntity toEntity() {
    return CouponEntity(
      id: couponId,
      code: code,
      discountType: discountType,
      value: value,
      expirationDate: expirationDate,
      maxUses: maxUses,
      currentUses: currentUses,
      isActive: isActive,
    );
  }

  static CouponModel fromEntity(CouponEntity entity) {
    return CouponModel()
      ..couponId = entity.id
      ..code = entity.code
      ..discountType = entity.discountType
      ..value = entity.value
      ..expirationDate = entity.expirationDate
      ..maxUses = entity.maxUses
      ..currentUses = entity.currentUses
      ..isActive = entity.isActive;
  }
}
