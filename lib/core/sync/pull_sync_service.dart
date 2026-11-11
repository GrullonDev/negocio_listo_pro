import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/core/sync/sync_cursor_model.dart';
import 'package:negocio_listo_pro/core/sync/sync_status.dart';
import 'package:negocio_listo_pro/features/bookings/data/models/booking_model.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/coupons/data/models/coupon_model.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/data/models/transaction_model.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/data/models/customer_model.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';

class PullSyncService {
  final ApiClient apiClient;
  final Isar isar;

  PullSyncService({required this.apiClient, required this.isar});

  Future<String?> _getCursor(String tenantId, SyncEntityType entityType) async {
    final cursor = await isar.syncCursorModels
        .filter()
        .tenantIdEqualTo(tenantId)
        .entityTypeEqualTo(entityType)
        .findFirst();
    return cursor?.cursor;
  }

  Future<void> _saveCursor(
    String tenantId,
    SyncEntityType entityType,
    String cursor,
  ) async {
    await isar.writeTxn(() async {
      var model = await isar.syncCursorModels
          .filter()
          .tenantIdEqualTo(tenantId)
          .entityTypeEqualTo(entityType)
          .findFirst();
      model ??= SyncCursorModel()
        ..tenantId = tenantId
        ..entityType = entityType;
      model
        ..cursor = cursor
        ..updatedAt = DateTime.now();
      await isar.syncCursorModels.put(model);
    });
  }

  String? _activeTenantId;

  Future<void> pullAll({String? tenantId}) async {
    _activeTenantId = tenantId;
    await pullTransactions();
    await pullBookings();
    await pullCustomers();
    await pullCoupons();
  }

  Future<int> pullTransactions() async {
    return _pull(
      entityType: SyncEntityType.transaction,
      tableName: 'transaction',
      upsert: (rows) async {
        await isar.writeTxn(() async {
          for (final json in rows) {
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
      },
    );
  }

  Future<int> pullBookings() async {
    return _pull(
      entityType: SyncEntityType.booking,
      tableName: 'booking',
      upsert: (rows) async {
        await isar.writeTxn(() async {
          for (final json in rows) {
            final id = json['id'] as String;
            final existing = await isar.bookingModels
                .filter()
                .bookingIdEqualTo(id)
                .findFirst();
            final model = existing ?? BookingModel();
            model
              ..bookingId = id
              ..clientName = json['client_name'] as String
              ..service = json['service'] as String
              ..date = DateTime.parse(json['start_at'] as String)
              ..status = BookingStatus.values.firstWhere(
                (s) => s.name == json['status'],
                orElse: () => BookingStatus.pending,
              );
            await isar.bookingModels.put(model);
          }
        });
      },
    );
  }

  Future<int> pullCustomers() async {
    return _pull(
      entityType: SyncEntityType.customer,
      tableName: 'customer',
      upsert: (rows) async {
        await isar.writeTxn(() async {
          for (final json in rows) {
            final id = json['id'] as String;
            final existing = await isar.customerModels
                .filter()
                .customerIdEqualTo(id)
                .findFirst();
            final model = existing ?? CustomerModel();
            model
              ..customerId = id
              ..name = json['name'] as String
              ..phone = (json['phone'] as String?) ?? ''
              ..points = json['points'] as int? ?? 0
              ..tier = LoyaltyTier.values.firstWhere(
                (t) => t.name == json['tier'],
                orElse: () => LoyaltyTier.bronze,
              );
            await isar.customerModels.put(model);
          }
        });
      },
    );
  }

  Future<int> pullCoupons() async {
    return _pull(
      entityType: SyncEntityType.coupon,
      tableName: 'coupon',
      upsert: (rows) async {
        await isar.writeTxn(() async {
          for (final json in rows) {
            final id = json['id'] as String;
            final existing = await isar.couponModels
                .filter()
                .couponIdEqualTo(id)
                .findFirst();
            final model = existing ?? CouponModel();
            model
              ..couponId = id
              ..code = json['code'] as String
              ..discountType = DiscountType.values.firstWhere(
                (d) => d.name == json['discount_type'],
                orElse: () => DiscountType.percentage,
              )
              ..value = double.parse(json['value'].toString())
              ..expirationDate =
                  DateTime.parse(json['expiration_date'] as String)
              ..maxUses = json['max_uses'] as int? ?? 0
              ..currentUses = json['current_uses'] as int? ?? 0
              ..isActive = json['is_active'] as bool? ?? true;
            await isar.couponModels.put(model);
          }
        });
      },
    );
  }

  Future<int> _pull({
    required SyncEntityType entityType,
    required String tableName,
    required Future<void> Function(List<Map<String, dynamic>>) upsert,
  }) async {
    final tenantId = _activeTenantId;
    final cursor = tenantId != null
        ? await _getCursor(tenantId, entityType)
        : null;
    final queryParams = <String, String>{
      'entity_type': tableName,
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
    final rows = (data['data'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    if (rows.isEmpty) return 0;

    await upsert(rows);

    if (data['cursor'] != null && tenantId != null) {
      await _saveCursor(tenantId, entityType, data['cursor'] as String);
    }

    return rows.length;
  }
}
