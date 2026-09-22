import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/usecases/add_customer_usecase.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/usecases/add_points_to_customer_usecase.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/usecases/get_customers_usecase.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_event.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_state.dart';

class LoyaltyBloc extends Bloc<LoyaltyEvent, LoyaltyState> {
  final GetCustomersUseCase getCustomersUseCase;
  final AddCustomerUseCase addCustomerUseCase;
  final AddPointsToCustomerUseCase addPointsToCustomerUseCase;

  LoyaltyBloc({
    required this.getCustomersUseCase,
    required this.addCustomerUseCase,
    required this.addPointsToCustomerUseCase,
  }) : super(const LoyaltyInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<AddCustomerRequested>(_onAddCustomer);
    on<AddPointsRequested>(_onAddPoints);
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<LoyaltyState> emit,
  ) async {
    emit(const LoyaltyLoading());
    final result = await getCustomersUseCase(const NoParams());
    result.fold(
      (failure) => emit(LoyaltyError(failure.message)),
      (customers) => emit(LoyaltyLoaded(customers)),
    );
  }

  Future<void> _onAddCustomer(
    AddCustomerRequested event,
    Emitter<LoyaltyState> emit,
  ) async {
    final result = await addCustomerUseCase(event.customer);
    await result.fold(
      (failure) async => emit(LoyaltyError(failure.message)),
      (_) => _onLoadCustomers(const LoadCustomers(), emit),
    );
  }

  Future<void> _onAddPoints(
    AddPointsRequested event,
    Emitter<LoyaltyState> emit,
  ) async {
    final result = await addPointsToCustomerUseCase(
      AddPointsParams(customerId: event.customerId, points: event.points),
    );
    await result.fold(
      (failure) async => emit(LoyaltyError(failure.message)),
      (_) => _onLoadCustomers(const LoadCustomers(), emit),
    );
  }
}
