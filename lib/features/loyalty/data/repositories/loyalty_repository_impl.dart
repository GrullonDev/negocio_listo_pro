import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/session/session_context.dart';
import 'package:negocio_listo_pro/core/sync/sync_repository.dart';
import 'package:negocio_listo_pro/core/sync/sync_service.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';
import 'package:negocio_listo_pro/features/loyalty/data/datasources/loyalty_local_datasource.dart';
import 'package:negocio_listo_pro/features/loyalty/data/models/customer_model.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/repositories/loyalty_repository.dart';

class LoyaltyRepositoryImpl implements LoyaltyRepository {
  final LoyaltyLocalDataSource localDataSource;
  final SyncRepository syncRepository;
  final SyncService syncService;
  final SessionContext sessionContext;

  const LoyaltyRepositoryImpl({
    required this.localDataSource,
    required this.syncRepository,
    required this.syncService,
    required this.sessionContext,
  });

  @override
  Future<Either<Failure, List<CustomerLoyaltyEntity>>> getCustomers() async {
    try {
      final customers = await localDataSource.getCustomers();
      return Right(customers.map((model) => model.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addCustomer(
    CustomerLoyaltyEntity customer,
  ) async {
    try {
      await localDataSource.addCustomer(CustomerModel.fromEntity(customer));

      final tenantId = sessionContext.tenantId;
      if (tenantId != null && sessionContext.isRemoteSession) {
        await syncRepository.enqueue(
          tenantId: tenantId,
          entityType: SyncEntityType.customer,
          entityId: customer.id,
          operationType: SyncOperationType.create,
          payload: {
            'name': customer.name,
            'phone': customer.phone,
          },
        );
        syncService.triggerSync();
      }

      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addPoints(
    String customerId,
    int points,
  ) async {
    try {
      await localDataSource.addPoints(customerId, points);

      final tenantId = sessionContext.tenantId;
      if (tenantId != null && sessionContext.isRemoteSession) {
        await syncRepository.enqueue(
          tenantId: tenantId,
          entityType: SyncEntityType.customer,
          entityId: customerId,
          operationType: SyncOperationType.update,
          payload: {'points': points},
        );
        syncService.triggerSync();
      }

      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
