import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/core/sync/sync_operation_model.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';

Future<bool> couponSyncDispatcher(
  SyncOperationModel op,
  ApiClient apiClient,
) async {
  switch (op.operationType) {
    case SyncOperationType.create:
      return _syncCreate(op, apiClient);
    case SyncOperationType.update:
      return _syncRedeem(op, apiClient);
    case SyncOperationType.delete:
      return false;
  }
}

Future<bool> _syncCreate(SyncOperationModel op, ApiClient apiClient) async {
  final payload = op.payload;
  final response = await apiClient.post(
    '/api/v1/coupons',
    body: {
      'code': payload['code'],
      'discount_type': payload['discount_type'],
      'value': payload['value'],
      'expiration_date': payload['expiration_date'],
      'max_uses': payload['max_uses'],
      'idempotency_key': op.operationId,
    },
  );
  if (response.isOffline) throw Exception('Sin conexión al servidor');
  return response.isSuccess;
}

Future<bool> _syncRedeem(SyncOperationModel op, ApiClient apiClient) async {
  final payload = op.payload;
  final response = await apiClient.post(
    '/api/v1/coupons/redeem',
    body: {'code': payload['code'], 'idempotency_key': op.operationId},
  );
  if (response.isOffline) throw Exception('Sin conexión al servidor');
  return response.isSuccess || (response.statusCode == 409);
}
