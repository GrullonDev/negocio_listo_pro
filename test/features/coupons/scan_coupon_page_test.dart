import 'package:flutter_test/flutter_test.dart';

import 'package:negocio_listo_pro/features/coupons/presentation/pages/scan_coupon_page.dart';

void main() {
  group('ScanCouponPage.normalizeCode', () {
    test('código simple en mayúsculas y sin espacios', () {
      expect(ScanCouponPage.normalizeCode('  promo20 \n'), 'PROMO20');
    });

    test('código dentro de un enlace', () {
      expect(
        ScanCouponPage.normalizeCode('https://negocio.gt/cupon/verano10'),
        'VERANO10',
      );
      expect(
        ScanCouponPage.normalizeCode('https://negocio.gt/c?code=vip5'),
        'VIP5',
      );
    });
  });
}
