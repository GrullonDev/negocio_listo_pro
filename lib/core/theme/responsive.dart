import 'package:flutter/material.dart';

import 'package:negocio_listo_pro/core/theme/app_theme.dart';

/// Breakpoints por ancho lógico, alineados con `Layout & Spacing` del
/// DESIGN.md (mobile < 768 ≤ tablet).
abstract final class Breakpoints {
  /// Teléfonos pequeños (iPhone SE 1ª gen, Android de gama baja).
  static const double compact = 360;
  static const double tablet = 600;

  /// Ancho máximo del contenido para que no se estire en pantallas grandes
  /// o en horizontal.
  static const double maxContentWidth = 640;
}

/// Límites del escalado de texto del sistema: respeta la accesibilidad pero
/// evita que tamaños extremos rompan layouts pensados para POS.
abstract final class TextScaleLimits {
  static const double min = 0.85;
  static const double max = 1.3;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isCompact => screenWidth < Breakpoints.compact;
  bool get isTablet => screenWidth >= Breakpoints.tablet;

  /// `margin-mobile` en teléfonos, más estrecho en pantallas compactas y
  /// `gutter` en tablets.
  double get pageMargin => isCompact
      ? AppSpacing.gutterMobile
      : isTablet
      ? AppSpacing.gutter
      : AppSpacing.marginMobile;

  EdgeInsets get pagePadding => EdgeInsets.all(pageMargin);
}

/// Centra el contenido y limita su ancho a [Breakpoints.maxContentWidth].
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
