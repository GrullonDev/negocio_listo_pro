import 'dart:convert';

import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/sync/sync_status.dart';

part 'sync_operation_model.g.dart';

@collection
class SyncOperationModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String operationId;

  late String tenantId;

  @enumerated
  late SyncEntityType entityType;

  late String entityId;

  @enumerated
  late SyncOperationType operationType;

  late String payloadJson;

  late DateTime createdAt;

  @enumerated
  late SyncOperationState state;

  late int retryCount;

  String? lastError;

  DateTime? lastAttemptAt;

  DateTime? completedAt;

  @ignore
  Map<String, dynamic> get payload =>
      jsonDecode(payloadJson) as Map<String, dynamic>;

  set payload(Map<String, dynamic> value) => payloadJson = jsonEncode(value);
}
