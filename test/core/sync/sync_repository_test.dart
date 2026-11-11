import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/sync/sync_operation_model.dart';
import 'package:negocio_listo_pro/core/sync/sync_repository.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';

void main() {
  late Isar isar;
  late SyncRepository repo;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [SyncOperationModelSchema],
      directory: '.',
      name: 'test_sync_${DateTime.now().millisecondsSinceEpoch}',
    );
    repo = SyncRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('SyncRepository', () {
    test('enqueue creates a pending operation', () async {
      final op = await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-1',
        operationType: SyncOperationType.create,
        payload: {'description': 'Test', 'amount': 100.0},
      );

      expect(op.operationId, isNotEmpty);
      expect(op.state, SyncOperationState.pending);
      expect(op.retryCount, 0);
    });

    test('getPending returns pending and failed operations', () async {
      await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-1',
        operationType: SyncOperationType.create,
        payload: {'test': true},
      );

      final pending = await repo.getPending();
      expect(pending, hasLength(1));
    });

    test('markCompleted changes state', () async {
      final op = await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-1',
        operationType: SyncOperationType.create,
        payload: {'test': true},
      );

      await repo.markCompleted(op);

      final pending = await repo.getPending();
      expect(pending, isEmpty);
    });

    test('markFailed increments retry count', () async {
      final op = await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-1',
        operationType: SyncOperationType.create,
        payload: {'test': true},
      );

      await repo.markFailed(op, 'Connection timeout');
      expect(op.retryCount, 1);
      expect(op.lastError, 'Connection timeout');
      expect(op.state, SyncOperationState.failed);
    });

    test('operation survives close and reopen', () async {
      await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-1',
        operationType: SyncOperationType.create,
        payload: {'amount': 50.0},
      );

      final name = isar.name;
      await isar.close();

      isar = await Isar.open(
        [SyncOperationModelSchema],
        directory: '.',
        name: name,
      );
      final reopened = SyncRepository(isar);
      final pending = await reopened.getPending();
      expect(pending, hasLength(1));
      expect(pending.first.payload['amount'], 50.0);
    });

    test('clearCompleted removes only completed operations', () async {
      final op1 = await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-1',
        operationType: SyncOperationType.create,
        payload: {'test': true},
      );
      await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-2',
        operationType: SyncOperationType.create,
        payload: {'test': true},
      );

      await repo.markCompleted(op1);
      await repo.clearCompleted();

      final count = await repo.pendingCount();
      expect(count, 1);
    });

    test('pendingCount counts pending and failed', () async {
      final op = await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-1',
        operationType: SyncOperationType.create,
        payload: {},
      );
      await repo.enqueue(
        tenantId: 'tenant-1',
        entityType: SyncEntityType.transaction,
        entityId: 'tx-2',
        operationType: SyncOperationType.create,
        payload: {},
      );
      await repo.markFailed(op, 'error');

      expect(await repo.pendingCount(), 2);
    });
  });
}
