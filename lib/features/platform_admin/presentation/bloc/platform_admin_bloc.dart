import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/features/platform_admin/domain/entities/brand_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/platform_dashboard_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/platform_user_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/tenant_summary_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/repositories/platform_repository.dart';

// Events
abstract class PlatformAdminEvent {}

class PlatformLoginRequested extends PlatformAdminEvent {
  final String email;
  final String password;
  PlatformLoginRequested({required this.email, required this.password});
}

class PlatformDashboardRequested extends PlatformAdminEvent {}

class PlatformTenantsRequested extends PlatformAdminEvent {}

class PlatformBrandsRequested extends PlatformAdminEvent {}

class PlatformCreateTenantRequested extends PlatformAdminEvent {
  final Map<String, dynamic> data;
  PlatformCreateTenantRequested(this.data);
}

class PlatformCreateBrandRequested extends PlatformAdminEvent {
  final Map<String, dynamic> data;
  PlatformCreateBrandRequested(this.data);
}

class PlatformLogoutRequested extends PlatformAdminEvent {}

// States
abstract class PlatformAdminState {}

class PlatformAdminInitial extends PlatformAdminState {}

class PlatformAdminLoading extends PlatformAdminState {}

class PlatformLoginSuccess extends PlatformAdminState {
  final PlatformUserEntity user;
  PlatformLoginSuccess(this.user);
}

class PlatformLoginFailure extends PlatformAdminState {
  final String message;
  PlatformLoginFailure(this.message);
}

class PlatformDashboardLoaded extends PlatformAdminState {
  final PlatformDashboardEntity dashboard;
  final PlatformUserEntity user;
  PlatformDashboardLoaded({required this.dashboard, required this.user});
}

class PlatformTenantsLoaded extends PlatformAdminState {
  final List<TenantSummaryEntity> tenants;
  PlatformTenantsLoaded(this.tenants);
}

class PlatformBrandsLoaded extends PlatformAdminState {
  final List<BrandEntity> brands;
  PlatformBrandsLoaded(this.brands);
}

class PlatformOperationSuccess extends PlatformAdminState {
  final String message;
  final Map<String, dynamic>? data;
  PlatformOperationSuccess(this.message, {this.data});
}

class PlatformAdminError extends PlatformAdminState {
  final String message;
  PlatformAdminError(this.message);
}

class PlatformAdminLoggedOut extends PlatformAdminState {}

// Bloc
class PlatformAdminBloc
    extends Bloc<PlatformAdminEvent, PlatformAdminState> {
  final PlatformRepository repository;
  PlatformUserEntity? _currentUser;

  PlatformAdminBloc({required this.repository})
      : super(PlatformAdminInitial()) {
    on<PlatformLoginRequested>(_onLogin);
    on<PlatformDashboardRequested>(_onDashboard);
    on<PlatformTenantsRequested>(_onTenants);
    on<PlatformBrandsRequested>(_onBrands);
    on<PlatformCreateTenantRequested>(_onCreateTenant);
    on<PlatformCreateBrandRequested>(_onCreateBrand);
    on<PlatformLogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(
    PlatformLoginRequested event,
    Emitter<PlatformAdminState> emit,
  ) async {
    emit(PlatformAdminLoading());
    final result = await repository.login(event.email, event.password);
    result.fold(
      (failure) => emit(PlatformLoginFailure(failure.toString())),
      (user) {
        _currentUser = user;
        emit(PlatformLoginSuccess(user));
      },
    );
  }

  Future<void> _onDashboard(
    PlatformDashboardRequested event,
    Emitter<PlatformAdminState> emit,
  ) async {
    emit(PlatformAdminLoading());
    final result = await repository.getDashboard();
    result.fold(
      (failure) => emit(PlatformAdminError(failure.toString())),
      (dashboard) {
        if (_currentUser != null) {
          emit(PlatformDashboardLoaded(
              dashboard: dashboard, user: _currentUser!));
        }
      },
    );
  }

  Future<void> _onTenants(
    PlatformTenantsRequested event,
    Emitter<PlatformAdminState> emit,
  ) async {
    emit(PlatformAdminLoading());
    final result = await repository.listTenants();
    result.fold(
      (failure) => emit(PlatformAdminError(failure.toString())),
      (tenants) => emit(PlatformTenantsLoaded(tenants)),
    );
  }

  Future<void> _onBrands(
    PlatformBrandsRequested event,
    Emitter<PlatformAdminState> emit,
  ) async {
    emit(PlatformAdminLoading());
    final result = await repository.listBrands();
    result.fold(
      (failure) => emit(PlatformAdminError(failure.toString())),
      (brands) => emit(PlatformBrandsLoaded(brands)),
    );
  }

  Future<void> _onCreateTenant(
    PlatformCreateTenantRequested event,
    Emitter<PlatformAdminState> emit,
  ) async {
    emit(PlatformAdminLoading());
    final result = await repository.createTenant(event.data);
    result.fold(
      (failure) => emit(PlatformAdminError(failure.toString())),
      (data) => emit(PlatformOperationSuccess('Negocio creado', data: data)),
    );
  }

  Future<void> _onCreateBrand(
    PlatformCreateBrandRequested event,
    Emitter<PlatformAdminState> emit,
  ) async {
    emit(PlatformAdminLoading());
    final result = await repository.createBrand(event.data);
    result.fold(
      (failure) => emit(PlatformAdminError(failure.toString())),
      (data) => emit(PlatformOperationSuccess('Marca creada', data: data)),
    );
  }

  void _onLogout(
    PlatformLogoutRequested event,
    Emitter<PlatformAdminState> emit,
  ) {
    _currentUser = null;
    emit(PlatformAdminLoggedOut());
  }
}
