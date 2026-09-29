import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:negocio_listo_pro/core/branding/brand_config.dart';

/// `branding/brands.conf` (nombre/ID nativo) y [BrandConfig.presets]
/// (identidad dentro de la app) deben describir las mismas marcas.
void main() {
  final rows = File('branding/brands.conf')
      .readAsLinesSync()
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty && !l.startsWith('#'))
      .map((l) => l.split('|'))
      .toList();

  test('mismas claves en brands.conf y BrandConfig.presets', () {
    expect(rows.map((r) => r[0]).toSet(), BrandConfig.presets.keys.toSet());
  });

  test('el nombre de la app coincide con businessName', () {
    for (final r in rows) {
      expect(r, hasLength(4), reason: r.join('|'));
      expect(r[1], BrandConfig.presets[r[0]]!.businessName, reason: r[0]);
    }
  });

  test('sufijos de ID únicos y válidos', () {
    final suffixes = rows.map((r) => r[2]).toList();
    expect(suffixes.toSet(), hasLength(suffixes.length));
    for (final s in suffixes.where((s) => s.isNotEmpty)) {
      expect(s, matches(RegExp(r'^\.[a-z][a-z0-9]*$')));
    }
  });
}
