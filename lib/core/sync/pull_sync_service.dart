import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';
import 'package:negocio_listo_pro/features/dashboard/data/models/transaction_model.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';

class PullSyncService {
  final ApiClient apiClient;
  final Isar isar;

  final Map<SyncEntityType, String?> _cursors = {};

  PullSyncService({required this.apiClient, required this.isar});

  Future<int> pullTransactions() async {
    final cursor = _cursors[SyncEntityType.transaction];
    final queryParams = <String, String>{
      'entity_type': 'transaction',
      'limit': '100',
      if (cursor != null) 'since': cursor,
    };

    final path = Uri(
      path: '/api/v1/sync/changes',
      queryParameters: queryParams,
    ).toString();

    final response = await apiClient.get(path);
    if (!response.isSuccess || response.data == null) return 0;

    final data = response.data!;
    final rows = data['data'] as List? ?? [];
    if (rows.isEmpty) return 0;

    await isar.writeTxn(() async {
      for (final item in rows) {
        final json = item as Map<String, dynamic>;
        final id = json['id'] as String;

        final existing = await isar.transactionModels
            .filter()
            .transactionIdEqualTo(id)
            .findFirst();

        final model = existing ?? TransactionModel();
        model
          ..transactionId = id
          ..description = json['description'] as String
          ..amount = double.parse(json['amount'].toString())
          ..type = json['type'] == 'income'
              ? TransactionType.income
              : TransactionType.expense
          ..date = DateTime.parse(json['occurred_at'] as String);

        await isar.transactionModels.put(model);
      }
    });

    if (data['cursor'] != null) {
      _cursors[SyncEntityType.transaction] = data['cursor'] as String;
    }

    return rows.length;
  }

  Future<void> pullAll() async {
    await pullTransactions();
  }
}
