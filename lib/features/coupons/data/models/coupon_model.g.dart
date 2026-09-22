// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCouponModelCollection on Isar {
  IsarCollection<CouponModel> get couponModels => this.collection();
}

const CouponModelSchema = CollectionSchema(
  name: r'CouponModel',
  id: -6909741856518233294,
  properties: {
    r'code': PropertySchema(id: 0, name: r'code', type: IsarType.string),
    r'couponId': PropertySchema(
      id: 1,
      name: r'couponId',
      type: IsarType.string,
    ),
    r'currentUses': PropertySchema(
      id: 2,
      name: r'currentUses',
      type: IsarType.long,
    ),
    r'discountType': PropertySchema(
      id: 3,
      name: r'discountType',
      type: IsarType.byte,
      enumMap: _CouponModeldiscountTypeEnumValueMap,
    ),
    r'expirationDate': PropertySchema(
      id: 4,
      name: r'expirationDate',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(id: 5, name: r'isActive', type: IsarType.bool),
    r'maxUses': PropertySchema(id: 6, name: r'maxUses', type: IsarType.long),
    r'value': PropertySchema(id: 7, name: r'value', type: IsarType.double),
  },

  estimateSize: _couponModelEstimateSize,
  serialize: _couponModelSerialize,
  deserialize: _couponModelDeserialize,
  deserializeProp: _couponModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'couponId': IndexSchema(
      id: 1045719118075916504,
      name: r'couponId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'couponId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'code': IndexSchema(
      id: 329780482934683790,
      name: r'code',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'code',
          type: IndexType.hash,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _couponModelGetId,
  getLinks: _couponModelGetLinks,
  attach: _couponModelAttach,
  version: '3.3.2',
);

int _couponModelEstimateSize(
  CouponModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.couponId.length * 3;
  return bytesCount;
}

void _couponModelSerialize(
  CouponModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.code);
  writer.writeString(offsets[1], object.couponId);
  writer.writeLong(offsets[2], object.currentUses);
  writer.writeByte(offsets[3], object.discountType.index);
  writer.writeDateTime(offsets[4], object.expirationDate);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeLong(offsets[6], object.maxUses);
  writer.writeDouble(offsets[7], object.value);
}

CouponModel _couponModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CouponModel();
  object.code = reader.readString(offsets[0]);
  object.couponId = reader.readString(offsets[1]);
  object.currentUses = reader.readLong(offsets[2]);
  object.discountType =
      _CouponModeldiscountTypeValueEnumMap[reader.readByteOrNull(offsets[3])] ??
      DiscountType.percentage;
  object.expirationDate = reader.readDateTime(offsets[4]);
  object.id = id;
  object.isActive = reader.readBool(offsets[5]);
  object.maxUses = reader.readLong(offsets[6]);
  object.value = reader.readDouble(offsets[7]);
  return object;
}

P _couponModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (_CouponModeldiscountTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DiscountType.percentage)
          as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CouponModeldiscountTypeEnumValueMap = {
  'percentage': 0,
  'fixedAmount': 1,
};
const _CouponModeldiscountTypeValueEnumMap = {
  0: DiscountType.percentage,
  1: DiscountType.fixedAmount,
};

Id _couponModelGetId(CouponModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _couponModelGetLinks(CouponModel object) {
  return [];
}

void _couponModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CouponModel object,
) {
  object.id = id;
}

extension CouponModelByIndex on IsarCollection<CouponModel> {
  Future<CouponModel?> getByCouponId(String couponId) {
    return getByIndex(r'couponId', [couponId]);
  }

  CouponModel? getByCouponIdSync(String couponId) {
    return getByIndexSync(r'couponId', [couponId]);
  }

  Future<bool> deleteByCouponId(String couponId) {
    return deleteByIndex(r'couponId', [couponId]);
  }

  bool deleteByCouponIdSync(String couponId) {
    return deleteByIndexSync(r'couponId', [couponId]);
  }

  Future<List<CouponModel?>> getAllByCouponId(List<String> couponIdValues) {
    final values = couponIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'couponId', values);
  }

  List<CouponModel?> getAllByCouponIdSync(List<String> couponIdValues) {
    final values = couponIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'couponId', values);
  }

  Future<int> deleteAllByCouponId(List<String> couponIdValues) {
    final values = couponIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'couponId', values);
  }

  int deleteAllByCouponIdSync(List<String> couponIdValues) {
    final values = couponIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'couponId', values);
  }

  Future<Id> putByCouponId(CouponModel object) {
    return putByIndex(r'couponId', object);
  }

  Id putByCouponIdSync(CouponModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'couponId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCouponId(List<CouponModel> objects) {
    return putAllByIndex(r'couponId', objects);
  }

  List<Id> putAllByCouponIdSync(
    List<CouponModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'couponId', objects, saveLinks: saveLinks);
  }

  Future<CouponModel?> getByCode(String code) {
    return getByIndex(r'code', [code]);
  }

  CouponModel? getByCodeSync(String code) {
    return getByIndexSync(r'code', [code]);
  }

  Future<bool> deleteByCode(String code) {
    return deleteByIndex(r'code', [code]);
  }

  bool deleteByCodeSync(String code) {
    return deleteByIndexSync(r'code', [code]);
  }

  Future<List<CouponModel?>> getAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndex(r'code', values);
  }

  List<CouponModel?> getAllByCodeSync(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'code', values);
  }

  Future<int> deleteAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'code', values);
  }

  int deleteAllByCodeSync(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'code', values);
  }

  Future<Id> putByCode(CouponModel object) {
    return putByIndex(r'code', object);
  }

  Id putByCodeSync(CouponModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'code', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCode(List<CouponModel> objects) {
    return putAllByIndex(r'code', objects);
  }

  List<Id> putAllByCodeSync(
    List<CouponModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'code', objects, saveLinks: saveLinks);
  }
}

extension CouponModelQueryWhereSort
    on QueryBuilder<CouponModel, CouponModel, QWhere> {
  QueryBuilder<CouponModel, CouponModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CouponModelQueryWhere
    on QueryBuilder<CouponModel, CouponModel, QWhereClause> {
  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> couponIdEqualTo(
    String couponId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'couponId', value: [couponId]),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> couponIdNotEqualTo(
    String couponId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'couponId',
                lower: [],
                upper: [couponId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'couponId',
                lower: [couponId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'couponId',
                lower: [couponId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'couponId',
                lower: [],
                upper: [couponId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> codeEqualTo(
    String code,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'code', value: [code]),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterWhereClause> codeNotEqualTo(
    String code,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [],
                upper: [code],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [code],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [code],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [],
                upper: [code],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CouponModelQueryFilter
    on QueryBuilder<CouponModel, CouponModel, QFilterCondition> {
  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'code',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'code',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> couponIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'couponId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  couponIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'couponId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  couponIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'couponId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> couponIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'couponId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  couponIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'couponId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  couponIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'couponId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  couponIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'couponId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> couponIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'couponId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  couponIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'couponId', value: ''),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  couponIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'couponId', value: ''),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  currentUsesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentUses', value: value),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  currentUsesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentUses',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  currentUsesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentUses',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  currentUsesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentUses',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  discountTypeEqualTo(DiscountType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'discountType', value: value),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  discountTypeGreaterThan(DiscountType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'discountType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  discountTypeLessThan(DiscountType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'discountType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  discountTypeBetween(
    DiscountType lower,
    DiscountType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'discountType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  expirationDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'expirationDate', value: value),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  expirationDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'expirationDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  expirationDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'expirationDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  expirationDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'expirationDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> isActiveEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> maxUsesEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'maxUses', value: value),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  maxUsesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maxUses',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> maxUsesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maxUses',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> maxUsesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maxUses',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition>
  valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterFilterCondition> valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension CouponModelQueryObject
    on QueryBuilder<CouponModel, CouponModel, QFilterCondition> {}

extension CouponModelQueryLinks
    on QueryBuilder<CouponModel, CouponModel, QFilterCondition> {}

extension CouponModelQuerySortBy
    on QueryBuilder<CouponModel, CouponModel, QSortBy> {
  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByCouponId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'couponId', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByCouponIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'couponId', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByCurrentUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUses', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByCurrentUsesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUses', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByDiscountType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountType', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy>
  sortByDiscountTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountType', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByExpirationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationDate', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy>
  sortByExpirationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationDate', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByMaxUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxUses', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByMaxUsesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxUses', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension CouponModelQuerySortThenBy
    on QueryBuilder<CouponModel, CouponModel, QSortThenBy> {
  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByCouponId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'couponId', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByCouponIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'couponId', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByCurrentUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUses', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByCurrentUsesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUses', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByDiscountType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountType', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy>
  thenByDiscountTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discountType', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByExpirationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationDate', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy>
  thenByExpirationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationDate', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByMaxUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxUses', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByMaxUsesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxUses', Sort.desc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension CouponModelQueryWhereDistinct
    on QueryBuilder<CouponModel, CouponModel, QDistinct> {
  QueryBuilder<CouponModel, CouponModel, QDistinct> distinctByCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QDistinct> distinctByCouponId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'couponId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CouponModel, CouponModel, QDistinct> distinctByCurrentUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentUses');
    });
  }

  QueryBuilder<CouponModel, CouponModel, QDistinct> distinctByDiscountType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discountType');
    });
  }

  QueryBuilder<CouponModel, CouponModel, QDistinct> distinctByExpirationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expirationDate');
    });
  }

  QueryBuilder<CouponModel, CouponModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<CouponModel, CouponModel, QDistinct> distinctByMaxUses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxUses');
    });
  }

  QueryBuilder<CouponModel, CouponModel, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension CouponModelQueryProperty
    on QueryBuilder<CouponModel, CouponModel, QQueryProperty> {
  QueryBuilder<CouponModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CouponModel, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<CouponModel, String, QQueryOperations> couponIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'couponId');
    });
  }

  QueryBuilder<CouponModel, int, QQueryOperations> currentUsesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentUses');
    });
  }

  QueryBuilder<CouponModel, DiscountType, QQueryOperations>
  discountTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discountType');
    });
  }

  QueryBuilder<CouponModel, DateTime, QQueryOperations>
  expirationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expirationDate');
    });
  }

  QueryBuilder<CouponModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<CouponModel, int, QQueryOperations> maxUsesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxUses');
    });
  }

  QueryBuilder<CouponModel, double, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
