import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/usecases/add_transaction_usecase.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/usecases/get_dashboard_metrics_usecase.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardMetricsUseCase getDashboardMetricsUseCase;
  final AddTransactionUseCase addTransactionUseCase;

  DashboardBloc({
    required this.getDashboardMetricsUseCase,
    required this.addTransactionUseCase,
  }) : super(const DashboardInitial()) {
    on<LoadDashboardMetrics>(_onLoadMetrics);
    on<AddDashboardTransaction>(_onAddTransaction);
  }

  Future<void> _onLoadMetrics(
    LoadDashboardMetrics event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final result = await getDashboardMetricsUseCase(const NoParams());
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (metrics) => emit(DashboardLoaded(metrics)),
    );
  }

  Future<void> _onAddTransaction(
    AddDashboardTransaction event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await addTransactionUseCase(event.transaction);
    await result.fold(
      (failure) async => emit(DashboardError(failure.message)),
      (_) => _onLoadMetrics(const LoadDashboardMetrics(), emit),
    );
  }
}
