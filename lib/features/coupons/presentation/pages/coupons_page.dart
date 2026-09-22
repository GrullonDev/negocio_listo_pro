import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupones de Descuento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Canjear cupón',
            onPressed: () => RedeemCouponDialog.show(context),
          ),
        ],
      ),
      body: BlocConsumer<CouponBloc, CouponState>(
        listener: (context, state) {
          if (state is CouponLoaded && state.redeemMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.redeemMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state is CouponLoading || state is CouponInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CouponError) {
            return Center(child: Text(state.message));
          } else if (state is CouponLoaded) {
            return _CouponsList(coupons: state.coupons);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateCouponBottomSheet.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo cupón'),
      ),
    );
  }
}

class _CouponsList extends StatelessWidget {
  final List<CouponEntity> coupons;

  const _CouponsList({required this.coupons});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (coupons.isEmpty) {
      return Center(
        child: Text(
          'Aún no hay cupones creados',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CouponBloc>().add(const LoadCoupons());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: coupons.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          final statusColor = _statusColor(coupon);

          return Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusColor.withValues(alpha: 0.12),
                child: Icon(Icons.local_offer, color: statusColor),
              ),
              title: Text(coupon.code),
              subtitle: Text(
                '${_discountLabel(coupon)} · ${coupon.currentUses}/${coupon.maxUses} usos · '
                'vence ${coupon.expirationDate.day}/${coupon.expirationDate.month}/${coupon.expirationDate.year}',
              ),
              trailing: Text(
                _statusLabel(coupon),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _discountLabel(CouponEntity coupon) {
    return coupon.discountType == DiscountType.percentage
        ? '${coupon.value.toStringAsFixed(0)}% de descuento'
        : '\$${coupon.value.toStringAsFixed(2)} de descuento';
  }

  Color _statusColor(CouponEntity coupon) {
    if (!coupon.isRedeemable) return Colors.red;
    return Colors.green;
  }

  String _statusLabel(CouponEntity coupon) {
    if (!coupon.isActive) return 'Inactivo';
    if (coupon.isExpired) return 'Expirado';
    if (!coupon.hasUsesLeft) return 'Agotado';
    return 'Vigente';
  }
}
