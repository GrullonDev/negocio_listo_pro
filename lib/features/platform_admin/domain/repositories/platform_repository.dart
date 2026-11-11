import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/brand_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/platform_dashboard_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/platform_user_entity.dart';
import 'package:negocio_listo_pro/features/platform_admin/domain/entities/tenant_summary_entity.dart';

abstract class PlatformRepository {
  Future<Either<Failure, PlatformUserEntity>> login(
      String email, String password);

  Future<Either<Failure, PlatformUserEntity>> getMe();

  Future<Either<Failure, void>> changePassword(
      String currentPassword, String newPassword);

  Future<Either<Failure, PlatformDashboardEntity>> getDashboard();

  Future<Either<Failure, List<TenantSummaryEntity>>> listTenants();

  Future<Either<Failure, Map<String, dynamic>>> createTenant(
      Map<String, dynamic> data);

  Future<Either<Failure, List<BrandEntity>>> listBrands();

  Future<Either<Failure, Map<String, dynamic>>> createBrand(
      Map<String, dynamic> data);

  Future<Either<Failure, void>> updateBrand(
      String id, Map<String, dynamic> fields);

  Future<Either<Failure, void>> updateTenant(
      String id, Map<String, dynamic> fields);
}
