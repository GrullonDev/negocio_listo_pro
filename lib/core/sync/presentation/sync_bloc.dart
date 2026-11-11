import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/session/session_context.dart';
import 'package:negocio_listo_pro/core/sync/pull_sync_service.dart';
import 'package:negocio_listo_pro/core/sync/sync_repository.dart';
import 'package:negocio_listo_pro/core/sync/sync_service.dart';

// Events
abstract class SyncEvent {}

class SyncStarted extends SyncEvent {}

class SyncRequested extends SyncEvent {}

class _SyncStatusUpdated extends SyncEvent {
  final SyncServiceStatus status;
  _SyncStatusUpdated(this.status);
}

// States
class SyncState {
  final bool isConnected;
  final bool isSyncing;
  final int pendingOperations;

  const SyncState({
    this.isConnected = false,
    this.isSyncing = false,
    this.pendingOperations = 0,
  });

  SyncState copyWith({
    bool? isConnected,
    bool? isSyncing,
    int? pendingOperations,
  }) {
    return SyncState(
      isConnected: isConnected ?? this.isConnected,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingOperations: pendingOperations ?? this.pendingOperations,
    );
  }
}

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncService syncService;
  final PullSyncService pullSyncService;
  final SessionContext sessionContext;
  final SyncRepository syncRepository;
  StreamSubscription<SyncServiceStatus>? _statusSub;

  SyncBloc({
    required this.syncService,
    required this.pullSyncService,
    required this.sessionContext,
    required this.syncRepository,
  })
    : super(const SyncState()) {
    on<SyncStarted>(_onStarted);
    on<SyncRequested>(_onRequested);
    on<_SyncStatusUpdated>(_onStatusUpdated);
  }

  Future<void> _onStarted(SyncStarted event, Emitter<SyncState> emit) async {
    await syncRepository.recoverStuckOperations();
    _statusSub = syncService.statusStream.listen((status) {
      add(_SyncStatusUpdated(status));
    });
    syncService.start();
  }

  Future<void> _onRequested(
    SyncRequested event,
    Emitter<SyncState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));
    await syncService.processQueue();
    await pullSyncService.pullAll(tenantId: sessionContext.tenantId);
    emit(state.copyWith(isSyncing: false));
  }

  void _onStatusUpdated(_SyncStatusUpdated event, Emitter<SyncState> emit) {
    emit(
      state.copyWith(
        isConnected: event.status.isConnected,
        isSyncing: event.status.isSyncing,
        pendingOperations: event.status.pendingOperations,
      ),
    );
  }

  @override
  Future<void> close() {
    _statusSub?.cancel();
    syncService.dispose();
    return super.close();
  }
}
