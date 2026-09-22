import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_bloc.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_event.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_state.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/widgets/create_coupon_bottom_sheet.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/widgets/redeem_coupon_dialog.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CouponBloc, CouponState>(
      listener: (context, state) {
        if (state is CouponLoaded && state.redeemMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.redeemMessage!)));
        }
      },
      builder: (context, state) {
        if (state is CouponLoading || state is CouponInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CouponError) {
          return Center(child: Text(state.message));
        } else if (state is CouponLoaded) {
          return _CouponsScreen(coupons: state.coupons);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _CouponsScreen extends StatefulWidget {
  final List<CouponEntity> coupons;

  const _CouponsScreen({required this.coupons});

  @override
  State<_CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<_CouponsScreen> {
  final _codeController = TextEditingController();
  CouponEntity? _verifiedCoupon;
  bool _searched = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    CouponEntity? match;
    for (final coupon in widget.coupons) {
      if (coupon.code.toUpperCase() == code) {
        match = coupon;
        break;
      }
    }
    setState(() {
      _verifiedCoupon = match;
      _searched = true;
    });
  }

  void _redeemVerified() {
    final coupon = _verifiedCoupon;
    if (coupon == null) return;
    context.read<CouponBloc>().add(RedeemCouponRequested(coupon.code));
    setState(() {
      _verifiedCoupon = null;
      _searched = false;
      _codeController.clear();
    });
  }

  String _discountLabel(CouponEntity coupon) {
    return coupon.discountType == DiscountType.percentage
        ? '-${coupon.value.toStringAsFixed(0)}% de descuento'
        : '-\$${coupon.value.toStringAsFixed(2)} de descuento';
  }

  String _statusLabel(CouponEntity coupon) {
    if (!coupon.isActive) return 'Inactivo';
    if (coupon.isExpired) return 'Expirado';
    if (!coupon.hasUsesLeft) return 'Agotado';
    return 'Vigente';
  }

  Color _statusColor(BuildContext context, CouponEntity coupon) {
    if (!coupon.isRedeemable) return Theme.of(context).colorScheme.error;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coupons = widget.coupons;
    final activeCount = coupons.where((c) => c.isRedeemable).length;
    final totalRedemptions = coupons.fold<int>(0, (sum, c) => sum + c.currentUses);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CouponBloc>().add(const LoadCoupons());
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SummaryCard(
            activeCount: activeCount,
            totalRedemptions: totalRedemptions,
            onNewCampaign: () => CreateCouponBottomSheet.show(context),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Validar y Canjear en Caja', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    'Ingresa el código del cupón del cliente',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm + 4),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _codeController,
                          textCapitalization: TextCapitalization.characters,
                          onSubmitted: (_) => _verify(),
                          decoration: InputDecoration(
                            hintText: 'PROMO20',
                            prefixIcon: const Icon(Icons.confirmation_number_outlined),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerLow,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.dm),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.dm),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      FilledButton(
                        onPressed: _verify,
                        child: const Text('Verificar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => RedeemCouponDialog.show(context),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Escanear Cupón QR de Cliente'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_searched) ...[
            const SizedBox(height: AppSpacing.md),
            _VerifyResultCard(
              coupon: _verifiedCoupon,
              discountLabel: _verifiedCoupon != null ? _discountLabel(_verifiedCoupon!) : '',
              onRedeem: _redeemVerified,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Campañas Vigentes', style: theme.textTheme.titleMedium),
              Text(
                '${coupons.length} disponibles',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (coupons.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'Aún no hay cupones creados',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ...coupons.map(
              (coupon) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
                child: _CampaignCard(
                  coupon: coupon,
                  discountLabel: _discountLabel(coupon),
                  statusLabel: _statusLabel(coupon),
                  statusColor: _statusColor(context, coupon),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int activeCount;
  final int totalRedemptions;
  final VoidCallback onNewCampaign;

  const _SummaryCard({
    required this.activeCount,
    required this.totalRedemptions,
    required this.onNewCampaign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, size: 16, color: scheme.primary),
              const SizedBox(width: 6),
              Text(
                'CUPONES ACTIVOS',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$totalRedemptions canjes totales',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onSuccessContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$activeCount',
                style: AppTheme.metricDisplay.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'vigentes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: onNewCampaign,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nueva Campaña'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerifyResultCard extends StatelessWidget {
  final CouponEntity? coupon;
  final String discountLabel;
  final VoidCallback onRedeem;

  const _VerifyResultCard({
    required this.coupon,
    required this.discountLabel,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = coupon;

    if (c == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.dangerContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.onDangerContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'No se encontró ningún cupón con ese código',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onDangerContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final redeemable = c.isRedeemable;
    final bg = redeemable ? AppColors.successContainer : AppColors.dangerContainer;
    final fg = redeemable ? AppColors.onSuccessContainer : AppColors.onDangerContainer;

    String reason = 'Válido para canjear';
    if (!redeemable) {
      if (!c.isActive) {
        reason = 'Este cupón está inactivo';
      } else if (c.isExpired) {
        reason = 'Este cupón expiró el '
            '${c.expirationDate.day}/${c.expirationDate.month}/${c.expirationDate.year}';
      } else if (!c.hasUsesLeft) {
        reason = 'Este cupón ya alcanzó su límite de usos';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                redeemable ? Icons.check_circle : Icons.error_outline,
                size: 16,
                color: fg,
              ),
              const SizedBox(width: 6),
              Text(
                reason,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                c.code,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                discountLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${c.currentUses}/${c.maxUses} usos · vence '
            '${c.expirationDate.day}/${c.expirationDate.month}/${c.expirationDate.year}',
            style: theme.textTheme.bodySmall?.copyWith(color: fg),
          ),
          if (redeemable) ...[
            const SizedBox(height: AppSpacing.sm + 4),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.successDark,
                ),
                onPressed: onRedeem,
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Confirmar Canje'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final CouponEntity coupon;
  final String discountLabel;
  final String statusLabel;
  final Color statusColor;

  const _CampaignCard({
    required this.coupon,
    required this.discountLabel,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = coupon.maxUses == 0
        ? 0.0
        : (coupon.currentUses / coupon.maxUses).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm + 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.dm),
                  ),
                  child: Icon(Icons.local_offer_outlined, color: statusColor, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.code,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        discountLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    statusLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm + 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation(statusColor),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Canjeados: ${coupon.currentUses} / ${coupon.maxUses}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Vence ${coupon.expirationDate.day}/${coupon.expirationDate.month}/${coupon.expirationDate.year}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
