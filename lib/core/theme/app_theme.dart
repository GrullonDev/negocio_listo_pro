import 'package:flutter/material.dart';

import 'package:negocio_listo_pro/core/branding/brand_config.dart';

/// Design tokens extraídos de `assets/design/DESIGN.md`. Sirven como fuente
/// única de verdad para colores que no forman parte del [ColorScheme] de
/// Material (estados de cupón/fidelización, pills de status, etc.).
abstract final class AppColors {
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color successContainer = Color(0xFFECFDF5);
  static const Color onSuccessContainer = Color(0xFF065F46);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFFFBEB);
  static const Color onWarningContainer = Color(0xFF92400E);

  static const Color dangerContainer = Color(0xFFFEF2F2);
  static const Color onDangerContainer = Color(0xFF991B1B);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerStrong = Color(0xFFDC2626);

  /// Neutral "slate obsidian" para tipografía de alto contraste.
  static const Color neutral = Color(0xFF0F172A);
  static const Color canvas = Color(0xFFF8FAFC);
  static const Color subtleSurface = Color(0xFFF1F5F9);

  static const Color mutedText = Color(0xFF64748B);
  static const Color placeholder = Color(0xFF94A3B8);
  static const Color hairline = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFCBD5E1);

  /// Acentos legibles sobre superficies `primary` (hero cards).
  static const Color onPrimaryPositive = Color(0xFF6CF8BB);
  static const Color onPrimaryNegative = Color(0xFFFCA5A5);
}

/// Radios estandarizados (`rounded` tokens del DESIGN.md).
abstract final class AppRadius {
  static const double sm = 4;
  static const double dm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;
}

/// Espaciado estandarizado (`spacing` tokens del DESIGN.md).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// Separación mínima del sub-grid de 4pt para detalles densos.
  static const double xxs = 2;

  /// `gutter-mobile` / `margin-mobile` / `gutter` / `margin`.
  static const double gutterMobile = 12;
  static const double marginMobile = 16;
  static const double gutter = 24;
  static const double margin = 32;
}

/// Tema visual de NegocioListo Pro, derivado 1:1 de los tokens de color y
/// tipografía definidos en `assets/design/DESIGN.md`.
abstract final class AppTheme {
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF00236F),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF1E3A8A),
    onPrimaryContainer: Color(0xFF90A8FF),
    secondary: Color(0xFF006C49),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF6CF8BB),
    onSecondaryContainer: Color(0xFF00714D),
    tertiary: Color(0xFF3E2400),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF5C3800),
    onTertiaryContainer: Color(0xFFEF9900),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFFAF8FF),
    onSurface: Color(0xFF131B2E),
    surfaceDim: Color(0xFFD2D9F4),
    surfaceBright: Color(0xFFFAF8FF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF2F3FF),
    surfaceContainer: Color(0xFFEAEDFF),
    surfaceContainerHigh: Color(0xFFE2E7FF),
    surfaceContainerHighest: Color(0xFFDAE2FD),
    onSurfaceVariant: Color(0xFF444651),
    outline: Color(0xFF757682),
    outlineVariant: Color(0xFFC5C5D3),
    inverseSurface: Color(0xFF283044),
    onInverseSurface: Color(0xFFEEF0FF),
    inversePrimary: Color(0xFFB6C4FF),
    surfaceTint: Color(0xFF4059AA),
  );

  /// Única familia tipográfica del sistema (empaquetada en `assets/fonts`
  /// para funcionar offline).
  static const String fontFamily = 'Inter';

  /// `tnum`: cifras tabulares para que montos y conteos no "bailen" al
  /// actualizarse en vivo.
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  static TextStyle _style(
    double size,
    FontWeight weight,
    double lineHeight,
    double trackingEm,
    Color color,
  ) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: lineHeight / size,
      letterSpacing: trackingEm * size,
      color: color,
      fontFeatures: _tabular,
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final onSurface = scheme.onSurface;
    return TextTheme(
      // display-lg-mobile
      displayLarge: _style(30, FontWeight.w700, 36, -0.02, onSurface),
      // headline-xl-mobile
      displayMedium: _style(24, FontWeight.w600, 32, -0.015, onSurface),
      // metric-display
      displaySmall: _style(28, FontWeight.w700, 32, -0.03, onSurface),
      // headline-lg
      headlineLarge: _style(24, FontWeight.w600, 32, -0.015, onSurface),
      // headline-md
      headlineMedium: _style(20, FontWeight.w600, 28, -0.01, onSurface),
      // headline-sm
      headlineSmall: _style(16, FontWeight.w600, 24, -0.005, onSurface),
      titleLarge: _style(20, FontWeight.w600, 28, -0.01, onSurface),
      titleMedium: _style(16, FontWeight.w600, 24, -0.005, onSurface),
      titleSmall: _style(14, FontWeight.w600, 20, 0.01, onSurface),
      // body-lg / body-md / body-sm
      bodyLarge: _style(16, FontWeight.w400, 24, 0, onSurface),
      bodyMedium: _style(14, FontWeight.w400, 20, 0, onSurface),
      bodySmall: _style(12, FontWeight.w400, 16, 0.005, AppColors.mutedText),
      // label-lg / label-md / label-sm
      labelLarge: _style(14, FontWeight.w500, 20, 0.01, onSurface),
      labelMedium: _style(12, FontWeight.w500, 16, 0.02, AppColors.mutedText),
      labelSmall: _style(
        11,
        FontWeight.w600,
        14,
        0.03,
        scheme.onSurfaceVariant,
      ),
    );
  }

  /// `metric-display` — reservado para balances/totales en dashboards.
  static const TextStyle metricDisplay = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 32 / 28,
    letterSpacing: -0.03 * 28,
    fontFeatures: _tabular,
  );

  static ThemeData get light => forBrand(BrandConfig.house);

  /// Same design system, recolored with the client's identity: only the
  /// brand-bearing roles change, so every screen adapts automatically.
  static ThemeData forBrand(BrandConfig brand) {
    final scheme = _lightScheme.copyWith(
      primary: brand.primary,
      primaryContainer: brand.primaryContainer,
      secondary: brand.secondary,
      surfaceTint: brand.primary,
    );
    final textTheme = _textTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainer,
        labelStyle: textTheme.labelSmall,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.dm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.dm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.dm),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.mutedText),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.placeholder),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.dm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.dm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.dm),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.dm),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dm),
        ),
        iconColor: scheme.primary,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedForegroundColor: scheme.onPrimary,
          selectedBackgroundColor: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.dm),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
        ),
        titleTextStyle: textTheme.headlineMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        modalElevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dm),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
