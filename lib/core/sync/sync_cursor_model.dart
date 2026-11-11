import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/core/sync/sync_status.dart';

part 'sync_cursor_model.g.dart';

@collection
class SyncCursorModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, composite: [CompositeIndex('entityType')])
  late String tenantId;

  @enumerated
  late SyncEntityType entityType;

  late String cursor;

  late DateTime updatedAt;
}
