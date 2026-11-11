import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/core/sync/sync_operation_model.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';

Future<bool> customerSyncDispatcher(
  SyncOperationModel op,
  ApiClient apiClient,
) async {
  switch (op.operationType) {
    case SyncOperationType.create:
      return _syncCreate(op, apiClient);
    case SyncOperationType.update:
      return _syncAddPoints(op, apiClient);
    case SyncOperationType.delete:
      return false;
  }
}

Future<bool> _syncCreate(SyncOperationModel op, ApiClient apiClient) async {
  final payload = op.payload;
  final response = await apiClient.post(
    '/api/v1/customers',
    body: {
      'name': payload['name'],
      'phone': payload['phone'],
      'idempotency_key': op.operationId,
    },
  );
  if (response.isOffline) throw Exception('Sin conexión al servidor');
  return response.isSuccess;
}

Future<bool> _syncAddPoints(SyncOperationModel op, ApiClient apiClient) async {
  final payload = op.payload;
  final response = await apiClient.post(
    '/api/v1/customers/${op.entityId}/points',
    body: {'points': payload['points'], 'idempotency_key': op.operationId},
  );
  if (response.isOffline) throw Exception('Sin conexión al servidor');
  return response.isSuccess;
}
