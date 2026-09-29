import 'package:flutter_test/flutter_test.dart';

import 'package:negocio_listo_pro/core/branding/brand_config.dart';

void main() {
  const brand = BrandConfig.house;

  test('usa Quetzales (GTQ) por defecto', () {
    expect(brand.currencyCode, 'GTQ');
    expect(brand.currencySymbol, 'Q');
  });

  test('formatea con separador de miles y dos decimales', () {
    expect(brand.formatMoney(0), 'Q0.00');
    expect(brand.formatMoney(999.5), 'Q999.50');
    expect(brand.formatMoney(1000), 'Q1,000.00');
    expect(brand.formatMoney(225800), 'Q225,800.00');
    expect(brand.formatMoney(1234567.891), 'Q1,234,567.89');
    expect(brand.formatMoney(-47900), '-Q47,900.00');
  });

  test('todas las marcas usan GTQ', () {
    for (final preset in BrandConfig.presets.values) {
      expect(preset.formatMoney(1500), 'Q1,500.00', reason: preset.key);
    }
  });
}
