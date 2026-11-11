import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/core/sync/sync_operation_model.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';

Future<bool> bookingSyncDispatcher(
  SyncOperationModel op,
  ApiClient apiClient,
) async {
  switch (op.operationType) {
    case SyncOperationType.create:
      return _syncCreate(op, apiClient);
    case SyncOperationType.update:
      return _syncUpdate(op, apiClient);
    case SyncOperationType.delete:
      return false;
  }
}

Future<bool> _syncCreate(SyncOperationModel op, ApiClient apiClient) async {
  final payload = op.payload;
  final response = await apiClient.post(
    '/api/v1/bookings',
    body: {
      'client_name': payload['client_name'],
      'service': payload['service'],
      'date': payload['date'],
      'idempotency_key': op.operationId,
    },
  );
  if (response.isOffline) throw Exception('Sin conexión al servidor');
  return response.isSuccess;
}

Future<bool> _syncUpdate(SyncOperationModel op, ApiClient apiClient) async {
  final payload = op.payload;
  final response = await apiClient.patch(
    '/api/v1/bookings/${op.entityId}',
    body: {'status': payload['status']},
  );
  if (response.isOffline) throw Exception('Sin conexión al servidor');
  return response.isSuccess;
}
