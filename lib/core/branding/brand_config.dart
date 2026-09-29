import 'package:flutter/material.dart';

/// Visual identity of the business the app is deployed for (white-label).
///
/// The active brand is chosen at build time with
/// `--dart-define=BRAND=<key>` (see [BrandConfig.presets]); without it the
/// NegocioListo Pro house brand is used. Adding a new client means adding
/// one entry to [presets] — no screen needs to change.
class BrandConfig {
  final String key;
  final String businessName;
  final String tagline;
  final Color primary;
  final Color primaryContainer;
  final Color secondary;

  /// Moneda local: Quetzal guatemalteco (GTQ) por defecto.
  final String currencyCode;
  final String currencySymbol;

  const BrandConfig({
    required this.key,
    required this.businessName,
    required this.tagline,
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    this.currencyCode = 'GTQ',
    this.currencySymbol = 'Q',
  });

  static const house = BrandConfig(
    key: 'default',
    businessName: 'NegocioListo Pro',
    tagline: 'Tu negocio, organizado y en crecimiento',
    primary: Color(0xFF00236F),
    primaryContainer: Color(0xFF1E3A8A),
    secondary: Color(0xFF006C49),
  );

  static const presets = <String, BrandConfig>{
    'default': house,
    'salon': BrandConfig(
      key: 'salon',
      businessName: 'Studio Bella',
      tagline: 'Belleza y cuidado personal',
      primary: Color(0xFF6D1B5E),
      primaryContainer: Color(0xFF8E2E7C),
      secondary: Color(0xFFB5838D),
    ),
    'barberia': BrandConfig(
      key: 'barberia',
      businessName: 'Barbería El Clásico',
      tagline: 'Estilo desde 1998',
      primary: Color(0xFF1F1F1F),
      primaryContainer: Color(0xFF3A3A3A),
      secondary: Color(0xFFB8860B),
    ),
    'clinica': BrandConfig(
      key: 'clinica',
      businessName: 'Clínica Dental Sonrisa',
      tagline: 'Tu sonrisa en buenas manos',
      primary: Color(0xFF006D77),
      primaryContainer: Color(0xFF168A94),
      secondary: Color(0xFF83C5BE),
    ),
  };

  /// Brand selected via `--dart-define=BRAND=...`, falling back to [house].
  static final BrandConfig current =
      presets[const String.fromEnvironment('BRAND', defaultValue: 'default')] ??
      house;

  /// Formato local de Guatemala: `Q1,234.56` (coma de miles, punto
  /// decimal). Los negativos se muestran como `-Q1,234.56`.
  String formatMoney(double amount) {
    final fixed = amount.abs().toStringAsFixed(2);
    final dot = fixed.indexOf('.');
    final integer = fixed.substring(0, dot);
    final grouped = integer.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    final sign = amount < 0 ? '-' : '';
    return '$sign$currencySymbol$grouped${fixed.substring(dot)}';
  }
}
