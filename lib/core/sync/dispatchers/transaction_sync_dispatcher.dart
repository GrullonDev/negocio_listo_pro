import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/core/sync/sync_operation_model.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';

Future<bool> transactionSyncDispatcher(
  SyncOperationModel op,
  ApiClient apiClient,
) async {
  switch (op.operationType) {
    case SyncOperationType.create:
      return _syncCreate(op, apiClient);
    case SyncOperationType.update:
    case SyncOperationType.delete:
      return false;
  }
}

Future<bool> _syncCreate(SyncOperationModel op, ApiClient apiClient) async {
  final payload = op.payload;
  final response = await apiClient.post(
    '/api/v1/transactions',
    body: {
      'description': payload['description'],
      'amount': payload['amount'],
      'type': payload['type'],
      'occurred_at': payload['occurred_at'],
      'idempotency_key': op.operationId,
    },
  );

  if (response.isOffline) {
    throw Exception('Sin conexión al servidor');
  }

  return response.isSuccess ||
      (response.data != null && response.data!['status'] == 'already_exists');
}
