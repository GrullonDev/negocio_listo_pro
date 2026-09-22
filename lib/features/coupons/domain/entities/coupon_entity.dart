enum DiscountType { percentage, fixedAmount }

class CouponEntity {
  final String id;
  final String code;
  final DiscountType discountType;
  final double value;
  final DateTime expirationDate;
  final int maxUses;
  final int currentUses;
  final bool isActive;

  const CouponEntity({
    required this.id,
    required this.code,
    required this.discountType,
    required this.value,
    required this.expirationDate,
    required this.maxUses,
    required this.currentUses,
    required this.isActive,
  });

  bool get isExpired => DateTime.now().isAfter(expirationDate);
  bool get hasUsesLeft => currentUses < maxUses;
  bool get isRedeemable => isActive && !isExpired && hasUsesLeft;

  CouponEntity copyWith({int? currentUses, bool? isActive}) {
    return CouponEntity(
      id: id,
      code: code,
      discountType: discountType,
      value: value,
      expirationDate: expirationDate,
      maxUses: maxUses,
      currentUses: currentUses ?? this.currentUses,
      isActive: isActive ?? this.isActive,
    );
  }
}
