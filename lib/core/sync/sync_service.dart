import 'dart:async';
import 'dart:math';

import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/core/sync/sync_operation_model.dart';
import 'package:negocio_listo_pro/core/sync/sync_repository.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';

typedef SyncDispatcher = Future<bool> Function(SyncOperationModel op);

class SyncService {
  final SyncRepository syncRepository;
  final ApiClient apiClient;
  final Map<SyncEntityType, SyncDispatcher> _dispatchers = {};

  static const int maxRetries = 10;
  static const Duration _baseInterval = Duration(seconds: 30);

  Timer? _timer;
  bool _running = false;

  final _statusController = StreamController<SyncServiceStatus>.broadcast();
  Stream<SyncServiceStatus> get statusStream => _statusController.stream;

  SyncService({required this.syncRepository, required this.apiClient});

  void registerDispatcher(SyncEntityType type, SyncDispatcher dispatcher) {
    _dispatchers[type] = dispatcher;
  }

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(_baseInterval, (_) => processQueue());
    processQueue();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> triggerSync() async {
    await processQueue();
  }

  Future<void> processQueue() async {
    if (_running) return;
    _running = true;

    try {
      final isOnline = await _checkConnectivity();
      if (!isOnline) {
        _emitStatus(connected: false);
        return;
      }

      final pending = await syncRepository.getPending();
      if (pending.isEmpty) {
        _emitStatus(connected: true, pendingCount: 0);
        return;
      }

      _emitStatus(connected: true, pendingCount: pending.length, syncing: true);

      for (final op in pending) {
        if (op.retryCount >= maxRetries) continue;

        final dispatcher = _dispatchers[op.entityType];
        if (dispatcher == null) {
          await syncRepository.markFailed(
            op,
            'No dispatcher for ${op.entityType.name}',
          );
          continue;
        }

        await syncRepository.markProcessing(op);

        try {
          final success = await dispatcher(op);
          if (success) {
            await syncRepository.markCompleted(op);
          } else {
            await syncRepository.markFailed(op, 'Dispatcher returned false');
          }
        } catch (e) {
          await syncRepository.markFailed(op, e.toString());
          final backoff = _calculateBackoff(op.retryCount);
          await Future<void>.delayed(backoff);
        }
      }

      final remaining = await syncRepository.pendingCount();
      _emitStatus(connected: true, pendingCount: remaining);
    } finally {
      _running = false;
    }
  }

  Future<bool> _checkConnectivity() async {
    try {
      final response = await apiClient.get('/health');
      return response.isSuccess;
    } catch (_) {
      return false;
    }
  }

  Duration _calculateBackoff(int retryCount) {
    final seconds = min(pow(2, retryCount).toInt(), 300);
    final jitter = Random().nextInt(max(1, seconds ~/ 2));
    return Duration(seconds: seconds + jitter);
  }

  void _emitStatus({
    required bool connected,
    int pendingCount = 0,
    bool syncing = false,
  }) {
    _statusController.add(
      SyncServiceStatus(
        isConnected: connected,
        pendingOperations: pendingCount,
        isSyncing: syncing,
      ),
    );
  }

  void dispose() {
    stop();
    _statusController.close();
  }
}

class SyncServiceStatus {
  final bool isConnected;
  final int pendingOperations;
  final bool isSyncing;

  const SyncServiceStatus({
    required this.isConnected,
    required this.pendingOperations,
    required this.isSyncing,
  });
}
