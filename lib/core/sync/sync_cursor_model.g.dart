// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_cursor_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncCursorModelCollection on Isar {
  IsarCollection<SyncCursorModel> get syncCursorModels => this.collection();
}

const SyncCursorModelSchema = CollectionSchema(
  name: r'SyncCursorModel',
  id: -5633630139823007711,
  properties: {
    r'cursor': PropertySchema(id: 0, name: r'cursor', type: IsarType.string),
    r'entityType': PropertySchema(
      id: 1,
      name: r'entityType',
      type: IsarType.byte,
      enumMap: _SyncCursorModelentityTypeEnumValueMap,
    ),
    r'tenantId': PropertySchema(
      id: 2,
      name: r'tenantId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _syncCursorModelEstimateSize,
  serialize: _syncCursorModelSerialize,
  deserialize: _syncCursorModelDeserialize,
  deserializeProp: _syncCursorModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'tenantId_entityType': IndexSchema(
      id: -7437536721368632435,
      name: r'tenantId_entityType',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tenantId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'entityType',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _syncCursorModelGetId,
  getLinks: _syncCursorModelGetLinks,
  attach: _syncCursorModelAttach,
  version: '3.3.2',
);

int _syncCursorModelEstimateSize(
  SyncCursorModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cursor.length * 3;
  bytesCount += 3 + object.tenantId.length * 3;
  return bytesCount;
}

void _syncCursorModelSerialize(
  SyncCursorModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cursor);
  writer.writeByte(offsets[1], object.entityType.index);
  writer.writeString(offsets[2], object.tenantId);
  writer.writeDateTime(offsets[3], object.updatedAt);
}

SyncCursorModel _syncCursorModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncCursorModel();
  object.cursor = reader.readString(offsets[0]);
  object.entityType =
      _SyncCursorModelentityTypeValueEnumMap[reader.readByteOrNull(
        offsets[1],
      )] ??
      SyncEntityType.transaction;
  object.id = id;
  object.tenantId = reader.readString(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  return object;
}

P _syncCursorModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_SyncCursorModelentityTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              SyncEntityType.transaction)
          as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SyncCursorModelentityTypeEnumValueMap = {
  'transaction': 0,
  'booking': 1,
  'customer': 2,
  'coupon': 3,
};
const _SyncCursorModelentityTypeValueEnumMap = {
  0: SyncEntityType.transaction,
  1: SyncEntityType.booking,
  2: SyncEntityType.customer,
  3: SyncEntityType.coupon,
};

Id _syncCursorModelGetId(SyncCursorModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncCursorModelGetLinks(SyncCursorModel object) {
  return [];
}

void _syncCursorModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  SyncCursorModel object,
) {
  object.id = id;
}

extension SyncCursorModelByIndex on IsarCollection<SyncCursorModel> {
  Future<SyncCursorModel?> getByTenantIdEntityType(
    String tenantId,
    SyncEntityType entityType,
  ) {
    return getByIndex(r'tenantId_entityType', [tenantId, entityType]);
  }

  SyncCursorModel? getByTenantIdEntityTypeSync(
    String tenantId,
    SyncEntityType entityType,
  ) {
    return getByIndexSync(r'tenantId_entityType', [tenantId, entityType]);
  }

  Future<bool> deleteByTenantIdEntityType(
    String tenantId,
    SyncEntityType entityType,
  ) {
    return deleteByIndex(r'tenantId_entityType', [tenantId, entityType]);
  }

  bool deleteByTenantIdEntityTypeSync(
    String tenantId,
    SyncEntityType entityType,
  ) {
    return deleteByIndexSync(r'tenantId_entityType', [tenantId, entityType]);
  }

  Future<List<SyncCursorModel?>> getAllByTenantIdEntityType(
    List<String> tenantIdValues,
    List<SyncEntityType> entityTypeValues,
  ) {
    final len = tenantIdValues.length;
    assert(
      entityTypeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tenantIdValues[i], entityTypeValues[i]]);
    }

    return getAllByIndex(r'tenantId_entityType', values);
  }

  List<SyncCursorModel?> getAllByTenantIdEntityTypeSync(
    List<String> tenantIdValues,
    List<SyncEntityType> entityTypeValues,
  ) {
    final len = tenantIdValues.length;
    assert(
      entityTypeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tenantIdValues[i], entityTypeValues[i]]);
    }

    return getAllByIndexSync(r'tenantId_entityType', values);
  }

  Future<int> deleteAllByTenantIdEntityType(
    List<String> tenantIdValues,
    List<SyncEntityType> entityTypeValues,
  ) {
    final len = tenantIdValues.length;
    assert(
      entityTypeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tenantIdValues[i], entityTypeValues[i]]);
    }

    return deleteAllByIndex(r'tenantId_entityType', values);
  }

  int deleteAllByTenantIdEntityTypeSync(
    List<String> tenantIdValues,
    List<SyncEntityType> entityTypeValues,
  ) {
    final len = tenantIdValues.length;
    assert(
      entityTypeValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([tenantIdValues[i], entityTypeValues[i]]);
    }

    return deleteAllByIndexSync(r'tenantId_entityType', values);
  }

  Future<Id> putByTenantIdEntityType(SyncCursorModel object) {
    return putByIndex(r'tenantId_entityType', object);
  }

  Id putByTenantIdEntityTypeSync(
    SyncCursorModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'tenantId_entityType', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTenantIdEntityType(List<SyncCursorModel> objects) {
    return putAllByIndex(r'tenantId_entityType', objects);
  }

  List<Id> putAllByTenantIdEntityTypeSync(
    List<SyncCursorModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'tenantId_entityType',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension SyncCursorModelQueryWhereSort
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QWhere> {
  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncCursorModelQueryWhere
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QWhereClause> {
  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  tenantIdEqualToAnyEntityType(String tenantId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'tenantId_entityType',
          value: [tenantId],
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  tenantIdNotEqualToAnyEntityType(String tenantId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tenantId_entityType',
                lower: [],
                upper: [tenantId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tenantId_entityType',
                lower: [tenantId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tenantId_entityType',
                lower: [tenantId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tenantId_entityType',
                lower: [],
                upper: [tenantId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  tenantIdEntityTypeEqualTo(String tenantId, SyncEntityType entityType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'tenantId_entityType',
          value: [tenantId, entityType],
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  tenantIdEqualToEntityTypeNotEqualTo(
    String tenantId,
    SyncEntityType entityType,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tenantId_entityType',
                lower: [tenantId],
                upper: [tenantId, entityType],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tenantId_entityType',
                lower: [tenantId, entityType],
                includeLower: false,
                upper: [tenantId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tenantId_entityType',
                lower: [tenantId, entityType],
                includeLower: false,
                upper: [tenantId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tenantId_entityType',
                lower: [tenantId],
                upper: [tenantId, entityType],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  tenantIdEqualToEntityTypeGreaterThan(
    String tenantId,
    SyncEntityType entityType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tenantId_entityType',
          lower: [tenantId, entityType],
          includeLower: include,
          upper: [tenantId],
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  tenantIdEqualToEntityTypeLessThan(
    String tenantId,
    SyncEntityType entityType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tenantId_entityType',
          lower: [tenantId],
          upper: [tenantId, entityType],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterWhereClause>
  tenantIdEqualToEntityTypeBetween(
    String tenantId,
    SyncEntityType lowerEntityType,
    SyncEntityType upperEntityType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tenantId_entityType',
          lower: [tenantId, lowerEntityType],
          includeLower: includeLower,
          upper: [tenantId, upperEntityType],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SyncCursorModelQueryFilter
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QFilterCondition> {
  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cursor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cursor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cursor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cursor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cursor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cursor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cursor',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cursor',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cursor', value: ''),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  cursorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cursor', value: ''),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  entityTypeEqualTo(SyncEntityType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entityType', value: value),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  entityTypeGreaterThan(SyncEntityType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entityType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  entityTypeLessThan(SyncEntityType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entityType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  entityTypeBetween(
    SyncEntityType lower,
    SyncEntityType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entityType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tenantId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tenantId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tenantId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tenantId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tenantId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tenantId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tenantId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tenantId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tenantId', value: ''),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  tenantIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tenantId', value: ''),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SyncCursorModelQueryObject
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QFilterCondition> {}

extension SyncCursorModelQueryLinks
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QFilterCondition> {}

extension SyncCursorModelQuerySortBy
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QSortBy> {
  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy> sortByCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cursor', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  sortByCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cursor', Sort.desc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  sortByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  sortByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  sortByTenantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  sortByTenantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.desc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SyncCursorModelQuerySortThenBy
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QSortThenBy> {
  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy> thenByCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cursor', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  thenByCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cursor', Sort.desc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  thenByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  thenByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  thenByTenantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  thenByTenantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.desc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SyncCursorModelQueryWhereDistinct
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QDistinct> {
  QueryBuilder<SyncCursorModel, SyncCursorModel, QDistinct> distinctByCursor({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cursor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QDistinct>
  distinctByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityType');
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QDistinct> distinctByTenantId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tenantId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncCursorModel, SyncCursorModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SyncCursorModelQueryProperty
    on QueryBuilder<SyncCursorModel, SyncCursorModel, QQueryProperty> {
  QueryBuilder<SyncCursorModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncCursorModel, String, QQueryOperations> cursorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cursor');
    });
  }

  QueryBuilder<SyncCursorModel, SyncEntityType, QQueryOperations>
  entityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityType');
    });
  }

  QueryBuilder<SyncCursorModel, String, QQueryOperations> tenantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenantId');
    });
  }

  QueryBuilder<SyncCursorModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
