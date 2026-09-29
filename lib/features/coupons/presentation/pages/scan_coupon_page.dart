import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:negocio_listo_pro/core/theme/app_theme.dart';

/// Pantalla completa que escanea el QR del cupón del cliente con la cámara.
///
/// Pide el permiso de cámara antes de encenderla. Si el usuario lo negó de
/// forma permanente, ofrece abrir los ajustes del sistema y vuelve a
/// comprobarlo al regresar a la app. Devuelve el código normalizado,
/// [manualEntry] si el usuario prefiere escribirlo, o `null` si cancela.
class ScanCouponPage extends StatefulWidget {
  const ScanCouponPage({super.key});

  /// Resultado cuando el usuario elige escribir el código a mano.
  static const manualEntry = '';

  static Future<String?> scan(BuildContext context) {
    return Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const ScanCouponPage()));
  }

  /// Acepta el código tal cual (`PROMO20`) o dentro de un enlace
  /// (`https://.../cupon/PROMO20`, `...?code=PROMO20`).
  static String normalizeCode(String raw) {
    final trimmed = raw.trim();
    final parts = trimmed.split(RegExp(r'[/=]'));
    final last = parts.lastWhere((p) => p.isNotEmpty, orElse: () => trimmed);
    return last.trim().toUpperCase();
  }

  @override
  State<ScanCouponPage> createState() => _ScanCouponPageState();
}

enum _CameraAccess { checking, granted, denied, permanentlyDenied }

class _ScanCouponPageState extends State<ScanCouponPage>
    with WidgetsBindingObserver {
  _CameraAccess _access = _CameraAccess.checking;
  MobileScannerController? _controller;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Al volver de los ajustes del sistema, revisa si ya se concedió.
    if (state == AppLifecycleState.resumed &&
        _access == _CameraAccess.permanentlyDenied) {
      _checkCamera();
    }
  }

  Future<void> _requestCamera() async {
    _apply(await Permission.camera.request());
  }

  Future<void> _checkCamera() async {
    _apply(await Permission.camera.status);
  }

  void _apply(PermissionStatus status) {
    if (!mounted) return;
    setState(() {
      if (status.isGranted || status.isLimited) {
        _controller ??= MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          formats: const [BarcodeFormat.qrCode],
        );
        _access = _CameraAccess.granted;
      } else if (status.isPermanentlyDenied || status.isRestricted) {
        _access = _CameraAccess.permanentlyDenied;
      } else {
        _access = _CameraAccess.denied;
      }
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.trim().isEmpty) continue;
      _handled = true;
      Navigator.of(context).pop(ScanCouponPage.normalizeCode(raw));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final scanning = _access == _CameraAccess.granted && controller != null;

    return Scaffold(
      backgroundColor: scanning ? Colors.black : null,
      appBar: AppBar(
        title: const Text('Escanear cupón'),
        backgroundColor: scanning ? Colors.black : null,
        foregroundColor: scanning ? Colors.white : null,
        actions: [
          if (scanning)
            IconButton(
              tooltip: 'Linterna',
              icon: const Icon(Icons.flashlight_on_outlined),
              onPressed: controller.toggleTorch,
            ),
        ],
      ),
      body: switch (_access) {
        _CameraAccess.checking => const Center(
          child: CircularProgressIndicator(),
        ),
        _CameraAccess.granted when controller != null => _ScannerView(
          controller: controller,
          onDetect: _onDetect,
        ),
        _CameraAccess.permanentlyDenied => const _PermissionMessage(
          title: 'Permiso de cámara desactivado',
          message:
              'Para escanear cupones, activa el permiso de cámara en los '
              'ajustes del teléfono. También puedes escribir el código '
              'manualmente.',
          actionLabel: 'Abrir ajustes',
          onAction: openAppSettings,
        ),
        _ => _PermissionMessage(
          title: 'Necesitamos tu cámara',
          message:
              'La usamos solo para leer el código QR del cupón del cliente. '
              'No se toman ni guardan fotos.',
          actionLabel: 'Permitir cámara',
          onAction: _requestCamera,
        ),
      },
    );
  }
}

class _ScannerView extends StatelessWidget {
  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;

  const _ScannerView({required this.controller, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Marco de encuadre proporcional a la pantalla (cabe en 320 px).
        final side = (constraints.biggest.shortestSide * 0.7).clamp(
          180.0,
          320.0,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: controller,
              onDetect: onDetect,
              errorBuilder: (context, error) => _PermissionMessage(
                title: 'No se pudo abrir la cámara',
                message: error.errorDetails?.message ?? error.errorCode.name,
                dark: true,
              ),
            ),
            Center(
              child: Container(
                width: side,
                height: side,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.xl + MediaQuery.viewPaddingOf(context).bottom,
              child: Text(
                'Apunta al código QR del cupón del cliente',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PermissionMessage extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool dark;

  const _PermissionMessage({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = dark ? Colors.white : theme.colorScheme.onSurface;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.no_photography_outlined, size: 56, color: fg),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(color: fg),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: dark ? Colors.white70 : AppColors.mutedText,
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(ScanCouponPage.manualEntry),
                child: const Text('Ingresar código manualmente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
