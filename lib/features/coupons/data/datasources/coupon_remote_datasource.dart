import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/features/coupons/data/models/coupon_model.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';

abstract class CouponRemoteDataSource {
  Future<List<CouponModel>> getCoupons();
  Future<CouponModel> createCoupon(CouponModel coupon);
  Future<CouponModel> redeemCoupon(String code, {String? idempotencyKey});
}

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  final ApiClient apiClient;

  const CouponRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<CouponModel>> getCoupons() async {
    final response = await apiClient.get('/api/v1/coupons');
    if (!response.isSuccess) throw Exception(response.errorMessage);

    final list =
        response.data!['data'] as List? ??
        (response.data is List ? response.data as List : []);
    return list.map(_fromJson).toList();
  }

  @override
  Future<CouponModel> createCoupon(CouponModel coupon) async {
    final response = await apiClient.post(
      '/api/v1/coupons',
      body: {
        'code': coupon.code,
        'discount_type': coupon.discountType.name,
        'value': coupon.value,
        'expiration_date': coupon.expirationDate.toUtc().toIso8601String(),
        'max_uses': coupon.maxUses,
      },
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return coupon;
  }

  @override
  Future<CouponModel> redeemCoupon(
    String code, {
    String? idempotencyKey,
  }) async {
    final response = await apiClient.post(
      '/api/v1/coupons/redeem',
      body: {
        'code': code,
        if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      },
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return _fromJson(response.data!);
  }

  CouponModel _fromJson(dynamic item) {
    final json = item as Map<String, dynamic>;
    return CouponModel()
      ..couponId = json['id'] as String
      ..code = json['code'] as String
      ..discountType = DiscountType.values.firstWhere(
        (d) => d.name == json['discount_type'],
        orElse: () => DiscountType.percentage,
      )
      ..value = double.parse(json['value'].toString())
      ..expirationDate = DateTime.parse(json['expiration_date'] as String)
      ..maxUses = json['max_uses'] as int? ?? 0
      ..currentUses = json['current_uses'] as int? ?? 0
      ..isActive = json['is_active'] as bool? ?? true;
  }
}
