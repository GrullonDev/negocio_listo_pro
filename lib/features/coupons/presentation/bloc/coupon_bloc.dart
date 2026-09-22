import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/coupons/domain/usecases/create_coupon_usecase.dart';
import 'package:negocio_listo_pro/features/coupons/domain/usecases/get_coupons_usecase.dart';
import 'package:negocio_listo_pro/features/coupons/domain/usecases/redeem_coupon_usecase.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_event.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final GetCouponsUseCase getCouponsUseCase;
  final CreateCouponUseCase createCouponUseCase;
  final RedeemCouponUseCase redeemCouponUseCase;

  CouponBloc({
    required this.getCouponsUseCase,
    required this.createCouponUseCase,
    required this.redeemCouponUseCase,
  }) : super(const CouponInitial()) {
    on<LoadCoupons>(_onLoadCoupons);
    on<CreateCouponRequested>(_onCreateCoupon);
    on<RedeemCouponRequested>(_onRedeemCoupon);
  }

  Future<void> _onLoadCoupons(
    LoadCoupons event,
    Emitter<CouponState> emit,
  ) async {
    emit(const CouponLoading());
    final result = await getCouponsUseCase(const NoParams());
    result.fold(
      (failure) => emit(CouponError(failure.message)),
      (coupons) => emit(CouponLoaded(coupons)),
    );
  }

  Future<void> _onCreateCoupon(
    CreateCouponRequested event,
    Emitter<CouponState> emit,
  ) async {
    final result = await createCouponUseCase(event.coupon);
    await result.fold(
      (failure) async => emit(CouponError(failure.message)),
      (_) => _onLoadCoupons(const LoadCoupons(), emit),
    );
  }

  Future<void> _onRedeemCoupon(
    RedeemCouponRequested event,
    Emitter<CouponState> emit,
  ) async {
    final result = await redeemCouponUseCase(RedeemCouponParams(event.code));

    await result.fold(
      (failure) => _emitRefreshed(emit, redeemMessage: failure.message),
      (coupon) => _emitRefreshed(
        emit,
        redeemMessage:
            'Cupón ${coupon.code} canjeado (${coupon.currentUses}/${coupon.maxUses})',
      ),
    );
  }

  Future<void> _emitRefreshed(
    Emitter<CouponState> emit, {
    required String redeemMessage,
  }) async {
    final refreshed = await getCouponsUseCase(const NoParams());
    refreshed.fold(
      (failure) => emit(CouponError(failure.message)),
      (coupons) => emit(CouponLoaded(coupons, redeemMessage: redeemMessage)),
    );
  }
}
