// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBookingModelCollection on Isar {
  IsarCollection<BookingModel> get bookingModels => this.collection();
}

const BookingModelSchema = CollectionSchema(
  name: r'BookingModel',
  id: 643181679485769242,
  properties: {
    r'bookingId': PropertySchema(
      id: 0,
      name: r'bookingId',
      type: IsarType.string,
    ),
    r'clientName': PropertySchema(
      id: 1,
      name: r'clientName',
      type: IsarType.string,
    ),
    r'date': PropertySchema(id: 2, name: r'date', type: IsarType.dateTime),
    r'service': PropertySchema(id: 3, name: r'service', type: IsarType.string),
    r'status': PropertySchema(
      id: 4,
      name: r'status',
      type: IsarType.byte,
      enumMap: _BookingModelstatusEnumValueMap,
    ),
  },

  estimateSize: _bookingModelEstimateSize,
  serialize: _bookingModelSerialize,
  deserialize: _bookingModelDeserialize,
  deserializeProp: _bookingModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookingId': IndexSchema(
      id: 4804924406505946939,
      name: r'bookingId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookingId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _bookingModelGetId,
  getLinks: _bookingModelGetLinks,
  attach: _bookingModelAttach,
  version: '3.3.2',
);

int _bookingModelEstimateSize(
  BookingModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookingId.length * 3;
  bytesCount += 3 + object.clientName.length * 3;
  bytesCount += 3 + object.service.length * 3;
  return bytesCount;
}

void _bookingModelSerialize(
  BookingModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookingId);
  writer.writeString(offsets[1], object.clientName);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeString(offsets[3], object.service);
  writer.writeByte(offsets[4], object.status.index);
}

BookingModel _bookingModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BookingModel();
  object.bookingId = reader.readString(offsets[0]);
  object.clientName = reader.readString(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.id = id;
  object.service = reader.readString(offsets[3]);
  object.status =
      _BookingModelstatusValueEnumMap[reader.readByteOrNull(offsets[4])] ??
      BookingStatus.pending;
  return object;
}

P _bookingModelDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_BookingModelstatusValueEnumMap[reader.readByteOrNull(offset)] ??
              BookingStatus.pending)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BookingModelstatusEnumValueMap = {
  'pending': 0,
  'confirmed': 1,
  'completed': 2,
  'cancelled': 3,
};
const _BookingModelstatusValueEnumMap = {
  0: BookingStatus.pending,
  1: BookingStatus.confirmed,
  2: BookingStatus.completed,
  3: BookingStatus.cancelled,
};

Id _bookingModelGetId(BookingModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bookingModelGetLinks(BookingModel object) {
  return [];
}

void _bookingModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  BookingModel object,
) {
  object.id = id;
}

extension BookingModelByIndex on IsarCollection<BookingModel> {
  Future<BookingModel?> getByBookingId(String bookingId) {
    return getByIndex(r'bookingId', [bookingId]);
  }

  BookingModel? getByBookingIdSync(String bookingId) {
    return getByIndexSync(r'bookingId', [bookingId]);
  }

  Future<bool> deleteByBookingId(String bookingId) {
    return deleteByIndex(r'bookingId', [bookingId]);
  }

  bool deleteByBookingIdSync(String bookingId) {
    return deleteByIndexSync(r'bookingId', [bookingId]);
  }

  Future<List<BookingModel?>> getAllByBookingId(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'bookingId', values);
  }

  List<BookingModel?> getAllByBookingIdSync(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'bookingId', values);
  }

  Future<int> deleteAllByBookingId(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'bookingId', values);
  }

  int deleteAllByBookingIdSync(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'bookingId', values);
  }

  Future<Id> putByBookingId(BookingModel object) {
    return putByIndex(r'bookingId', object);
  }

  Id putByBookingIdSync(BookingModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'bookingId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBookingId(List<BookingModel> objects) {
    return putAllByIndex(r'bookingId', objects);
  }

  List<Id> putAllByBookingIdSync(
    List<BookingModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'bookingId', objects, saveLinks: saveLinks);
  }
}

extension BookingModelQueryWhereSort
    on QueryBuilder<BookingModel, BookingModel, QWhere> {
  QueryBuilder<BookingModel, BookingModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BookingModelQueryWhere
    on QueryBuilder<BookingModel, BookingModel, QWhereClause> {
  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> bookingIdEqualTo(
    String bookingId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'bookingId', value: [bookingId]),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause>
  bookingIdNotEqualTo(String bookingId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bookingId',
                lower: [],
                upper: [bookingId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bookingId',
                lower: [bookingId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bookingId',
                lower: [bookingId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'bookingId',
                lower: [],
                upper: [bookingId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension BookingModelQueryFilter
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {
  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bookingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bookingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bookingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bookingId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bookingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bookingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bookingId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bookingId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bookingId', value: ''),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  bookingIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bookingId', value: ''),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clientName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'clientName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'clientName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clientName', value: ''),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  clientNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'clientName', value: ''),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> dateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  dateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'service',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'service',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'service',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'service',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'service',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'service',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'service',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'service',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'service', value: ''),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  serviceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'service', value: ''),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> statusEqualTo(
    BookingStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  statusGreaterThan(BookingStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
  statusLessThan(BookingStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> statusBetween(
    BookingStatus lower,
    BookingStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension BookingModelQueryObject
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {}

extension BookingModelQueryLinks
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {}

extension BookingModelQuerySortBy
    on QueryBuilder<BookingModel, BookingModel, QSortBy> {
  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByBookingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByBookingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByClientName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
  sortByClientNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByService() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'service', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByServiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'service', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension BookingModelQuerySortThenBy
    on QueryBuilder<BookingModel, BookingModel, QSortThenBy> {
  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByBookingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByBookingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByClientName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
  thenByClientNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByService() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'service', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByServiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'service', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension BookingModelQueryWhereDistinct
    on QueryBuilder<BookingModel, BookingModel, QDistinct> {
  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByBookingId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookingId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByClientName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByService({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'service', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension BookingModelQueryProperty
    on QueryBuilder<BookingModel, BookingModel, QQueryProperty> {
  QueryBuilder<BookingModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> bookingIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookingId');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> clientNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientName');
    });
  }

  QueryBuilder<BookingModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> serviceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'service');
    });
  }

  QueryBuilder<BookingModel, BookingStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
