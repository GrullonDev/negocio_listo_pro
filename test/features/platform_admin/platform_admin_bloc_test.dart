import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/brand_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/platform_dashboard_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/platform_user_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/tenant_summary_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/repositories/platform_repository.dart';
import 'package:negocio_listo_pro/features/platform_admin/presentation/bloc/platform_admin_bloc.dart';

class FakePlatformRepository implements PlatformRepository {
  bool loginShouldFail = false;

  @override
  Future<Either<Failure, PlatformUserEntity>> login(
      String email, String password) async {
    if (loginShouldFail) {
      return const Left(ServerFailure('Invalid credentials'));
    }
    return const Right(PlatformUserEntity(
      id: 'admin-1',
      name: 'Admin',
      email: 'admin@test.local',
      role: 'super_admin',
    ));
  }

  @override
  Future<Either<Failure, PlatformUserEntity>> getMe() async {
    return const Right(PlatformUserEntity(
      id: 'admin-1',
      name: 'Admin',
      email: 'admin@test.local',
      role: 'super_admin',
    ));
  }

  @override
  Future<Either<Failure, void>> changePassword(
          String currentPassword, String newPassword) async =>
      const Right(null);

  @override
  Future<Either<Failure, PlatformDashboardEntity>> getDashboard() async {
    return const Right(PlatformDashboardEntity(
      totalTenants: 3,
      activeTenants: 2,
      totalUsers: 5,
      totalBrands: 4,
      recentActivity: [],
    ));
  }

  @override
  Future<Either<Failure, List<TenantSummaryEntity>>> listTenants() async {
    return Right([
      TenantSummaryEntity(
        id: 't-1',
        name: 'Test Biz',
        businessType: 'general',
        currencyCode: 'GTQ',
        status: 'active',
        createdAt: DateTime(2024),
      ),
    ]);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createTenant(
          Map<String, dynamic> data) async =>
      const Right({'tenant_id': 't-new'});

  @override
  Future<Either<Failure, void>> updateTenant(
          String id, Map<String, dynamic> fields) async =>
      const Right(null);

  @override
  Future<Either<Failure, List<BrandEntity>>> listBrands() async {
    return const Right([
      BrandEntity(
        id: 'b-1',
        brandKey: 'default',
        displayName: 'NegocioListo Pro',
        tagline: '',
        primaryColor: '#00236F',
        secondaryColor: '#006C49',
        backgroundColor: '#FFFFFF',
        currencyCode: 'GTQ',
        currencySymbol: 'Q',
        isActive: true,
      ),
    ]);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createBrand(
          Map<String, dynamic> data) async =>
      const Right({'id': 'b-new'});

  @override
  Future<Either<Failure, void>> updateBrand(
          String id, Map<String, dynamic> fields) async =>
      const Right(null);
}

void main() {
  late FakePlatformRepository repository;
  late PlatformAdminBloc bloc;

  setUp(() {
    repository = FakePlatformRepository();
    bloc = PlatformAdminBloc(repository: repository);
  });

  tearDown(() => bloc.close());

  test('successful login emits PlatformLoginSuccess', () async {
    bloc.add(PlatformLoginRequested(
        email: 'admin@test.local', password: 'pass'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PlatformAdminLoading>(),
        isA<PlatformLoginSuccess>(),
      ]),
    );
  });

  test('failed login emits PlatformLoginFailure', () async {
    repository.loginShouldFail = true;
    bloc.add(PlatformLoginRequested(email: 'bad', password: 'bad'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PlatformAdminLoading>(),
        isA<PlatformLoginFailure>(),
      ]),
    );
  });

  test('dashboard request emits PlatformDashboardLoaded', () async {
    // Login first to set _currentUser
    bloc.add(PlatformLoginRequested(
        email: 'admin@test.local', password: 'pass'));
    await bloc.stream.firstWhere((s) => s is PlatformLoginSuccess);

    bloc.add(PlatformDashboardRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PlatformAdminLoading>(),
        isA<PlatformDashboardLoaded>(),
      ]),
    );
  });

  test('tenants request emits PlatformTenantsLoaded', () async {
    bloc.add(PlatformTenantsRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PlatformAdminLoading>(),
        isA<PlatformTenantsLoaded>(),
      ]),
    );
  });

  test('brands request emits PlatformBrandsLoaded', () async {
    bloc.add(PlatformBrandsRequested());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PlatformAdminLoading>(),
        isA<PlatformBrandsLoaded>(),
      ]),
    );
  });

  test('logout emits PlatformAdminLoggedOut', () async {
    bloc.add(PlatformLogoutRequested());

    await expectLater(
      bloc.stream,
      emits(isA<PlatformAdminLoggedOut>()),
    );
  });
}
