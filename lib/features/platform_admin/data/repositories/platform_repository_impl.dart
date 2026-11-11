import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/platform_admin/data/datasources/platform_remote_datasource.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/brand_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/platform_dashboard_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/platform_user_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/tenant_summary_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/repositories/platform_repository.dart';

class PlatformRepositoryImpl implements PlatformRepository {
  final PlatformRemoteDataSource remoteDataSource;

  const PlatformRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PlatformUserEntity>> login(
      String email, String password) async {
    try {
      final data = await remoteDataSource.login(email, password);
      final user = data['user'] as Map<String, dynamic>;
      return Right(PlatformUserEntity(
        id: user['id'] as String,
        name: user['name'] as String,
        email: user['email'] as String,
        role: user['role'] as String,
        mustChangePassword: user['must_change_password'] as bool? ?? false,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlatformUserEntity>> getMe() async {
    try {
      final data = await remoteDataSource.getMe();
      return Right(PlatformUserEntity(
        id: data['id'] as String,
        name: data['name'] as String,
        email: data['email'] as String,
        role: data['role'] as String,
        mustChangePassword: data['must_change_password'] as bool? ?? false,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await remoteDataSource.changePassword(currentPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlatformDashboardEntity>> getDashboard() async {
    try {
      final data = await remoteDataSource.getDashboard();
      final activity = (data['recent_activity'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map((a) => AuditEntry(
                id: a['id'] as String,
                action: a['action'] as String,
                targetType: a['target_type'] as String,
                targetId: a['target_id'] as String?,
                actorName: a['actor_name'] as String,
                createdAt: DateTime.parse(a['created_at'] as String),
              ))
          .toList();
      return Right(PlatformDashboardEntity(
        totalTenants: data['total_tenants'] as int,
        activeTenants: data['active_tenants'] as int,
        totalUsers: data['total_users'] as int,
        totalBrands: data['total_brands'] as int,
        recentActivity: activity,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TenantSummaryEntity>>> listTenants() async {
    try {
      final data = await remoteDataSource.listTenants();
      return Right(data
          .map((t) => TenantSummaryEntity(
                id: t['id'] as String,
                name: t['name'] as String,
                businessType: t['business_type'] as String,
                currencyCode: t['currency_code'] as String,
                status: t['status'] as String,
                brandName: t['brand_name'] as String?,
                createdAt: DateTime.parse(t['created_at'] as String),
              ))
          .toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createTenant(
      Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.createTenant(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTenant(
      String id, Map<String, dynamic> fields) async {
    try {
      await remoteDataSource.updateTenant(id, fields);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BrandEntity>>> listBrands() async {
    try {
      final data = await remoteDataSource.listBrands();
      return Right(data
          .map((b) => BrandEntity(
                id: b['id'] as String,
                brandKey: b['brand_key'] as String,
                displayName: b['display_name'] as String,
                tagline: b['tagline'] as String? ?? '',
                primaryColor: b['primary_color'] as String,
                secondaryColor: b['secondary_color'] as String,
                backgroundColor: b['background_color'] as String,
                currencyCode: b['currency_code'] as String,
                currencySymbol: b['currency_symbol'] as String,
                isActive: b['is_active'] as bool,
              ))
          .toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createBrand(
      Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.createBrand(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBrand(
      String id, Map<String, dynamic> fields) async {
    try {
      await remoteDataSource.updateBrand(id, fields);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
