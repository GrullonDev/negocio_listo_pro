import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:negocio_listo_pro/core/sync/sync_operation_model.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';

class SyncRepository {
  final Isar isar;
  static const _uuid = Uuid();

  const SyncRepository(this.isar);

  Future<SyncOperationModel> enqueue({
    required String tenantId,
    required SyncEntityType entityType,
    required String entityId,
    required SyncOperationType operationType,
    required Map<String, dynamic> payload,
  }) async {
    final op = SyncOperationModel()
      ..operationId = _uuid.v4()
      ..tenantId = tenantId
      ..entityType = entityType
      ..entityId = entityId
      ..operationType = operationType
      ..payloadJson = jsonEncode(payload)
      ..createdAt = DateTime.now().toUtc()
      ..state = SyncOperationState.pending
      ..retryCount = 0;

    await isar.writeTxn(() async {
      await isar.syncOperationModels.put(op);
    });
    return op;
  }

  Future<List<SyncOperationModel>> getPending({int limit = 50}) async {
    return isar.syncOperationModels
        .filter()
        .stateEqualTo(SyncOperationState.pending)
        .or()
        .stateEqualTo(SyncOperationState.failed)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  Future<void> markProcessing(SyncOperationModel op) async {
    op.state = SyncOperationState.processing;
    op.lastAttemptAt = DateTime.now().toUtc();
    await isar.writeTxn(() async {
      await isar.syncOperationModels.put(op);
    });
  }

  Future<void> markCompleted(SyncOperationModel op) async {
    op.state = SyncOperationState.completed;
    op.completedAt = DateTime.now().toUtc();
    await isar.writeTxn(() async {
      await isar.syncOperationModels.put(op);
    });
  }

  static const int maxRetries = 5;

  Future<void> recoverStuckOperations({
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final cutoff = DateTime.now().toUtc().subtract(timeout);
    final stuck = await isar.syncOperationModels
        .filter()
        .stateEqualTo(SyncOperationState.processing)
        .lastAttemptAtLessThan(cutoff)
        .findAll();
    if (stuck.isEmpty) return;
    await isar.writeTxn(() async {
      for (final op in stuck) {
        if (op.retryCount >= maxRetries) {
          op.state = SyncOperationState.terminal;
        } else {
          op.state = SyncOperationState.pending;
        }
        await isar.syncOperationModels.put(op);
      }
    });
  }

  Future<void> markFailed(SyncOperationModel op, String error) async {
    op.retryCount += 1;
    op.lastError = error;
    op.state = op.retryCount >= maxRetries
        ? SyncOperationState.terminal
        : SyncOperationState.failed;
    await isar.writeTxn(() async {
      await isar.syncOperationModels.put(op);
    });
  }

  Future<int> pendingCount() async {
    return isar.syncOperationModels
        .filter()
        .stateEqualTo(SyncOperationState.pending)
        .or()
        .stateEqualTo(SyncOperationState.failed)
        .count();
  }

  Future<void> clearCompleted() async {
    final completed = await isar.syncOperationModels
        .filter()
        .stateEqualTo(SyncOperationState.completed)
        .findAll();
    await isar.writeTxn(() async {
      await isar.syncOperationModels.deleteAll(
        completed.map((o) => o.id).toList(),
      );
    });
  }
}
