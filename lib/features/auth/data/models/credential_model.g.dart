// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCredentialModelCollection on Isar {
  IsarCollection<CredentialModel> get credentialModels => this.collection();
}

const CredentialModelSchema = CollectionSchema(
  name: r'CredentialModel',
  id: 8582107515564195326,
  properties: {
    r'displayName': PropertySchema(
      id: 0,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'email': PropertySchema(id: 1, name: r'email', type: IsarType.string),
    r'passwordHash': PropertySchema(
      id: 2,
      name: r'passwordHash',
      type: IsarType.string,
    ),
    r'tenant': PropertySchema(
      id: 3,
      name: r'tenant',
      type: IsarType.object,

      target: r'TenantModel',
    ),
    r'userId': PropertySchema(id: 4, name: r'userId', type: IsarType.string),
  },

  estimateSize: _credentialModelEstimateSize,
  serialize: _credentialModelSerialize,
  deserialize: _credentialModelDeserialize,
  deserializeProp: _credentialModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'email': IndexSchema(
      id: -26095440403582047,
      name: r'email',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'email',
          type: IndexType.hash,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'TenantModel': TenantModelSchema},

  getId: _credentialModelGetId,
  getLinks: _credentialModelGetLinks,
  attach: _credentialModelAttach,
  version: '3.3.2',
);

int _credentialModelEstimateSize(
  CredentialModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.email.length * 3;
  bytesCount += 3 + object.passwordHash.length * 3;
  bytesCount +=
      3 +
      TenantModelSchema.estimateSize(
        object.tenant,
        allOffsets[TenantModel]!,
        allOffsets,
      );
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _credentialModelSerialize(
  CredentialModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.displayName);
  writer.writeString(offsets[1], object.email);
  writer.writeString(offsets[2], object.passwordHash);
  writer.writeObject<TenantModel>(
    offsets[3],
    allOffsets,
    TenantModelSchema.serialize,
    object.tenant,
  );
  writer.writeString(offsets[4], object.userId);
}

CredentialModel _credentialModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CredentialModel();
  object.displayName = reader.readString(offsets[0]);
  object.email = reader.readString(offsets[1]);
  object.id = id;
  object.passwordHash = reader.readString(offsets[2]);
  object.tenant =
      reader.readObjectOrNull<TenantModel>(
        offsets[3],
        TenantModelSchema.deserialize,
        allOffsets,
      ) ??
      TenantModel();
  object.userId = reader.readString(offsets[4]);
  return object;
}

P _credentialModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<TenantModel>(
                offset,
                TenantModelSchema.deserialize,
                allOffsets,
              ) ??
              TenantModel())
          as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _credentialModelGetId(CredentialModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _credentialModelGetLinks(CredentialModel object) {
  return [];
}

void _credentialModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CredentialModel object,
) {
  object.id = id;
}

extension CredentialModelByIndex on IsarCollection<CredentialModel> {
  Future<CredentialModel?> getByEmail(String email) {
    return getByIndex(r'email', [email]);
  }

  CredentialModel? getByEmailSync(String email) {
    return getByIndexSync(r'email', [email]);
  }

  Future<bool> deleteByEmail(String email) {
    return deleteByIndex(r'email', [email]);
  }

  bool deleteByEmailSync(String email) {
    return deleteByIndexSync(r'email', [email]);
  }

  Future<List<CredentialModel?>> getAllByEmail(List<String> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return getAllByIndex(r'email', values);
  }

  List<CredentialModel?> getAllByEmailSync(List<String> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'email', values);
  }

  Future<int> deleteAllByEmail(List<String> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'email', values);
  }

  int deleteAllByEmailSync(List<String> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'email', values);
  }

  Future<Id> putByEmail(CredentialModel object) {
    return putByIndex(r'email', object);
  }

  Id putByEmailSync(CredentialModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'email', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEmail(List<CredentialModel> objects) {
    return putAllByIndex(r'email', objects);
  }

  List<Id> putAllByEmailSync(
    List<CredentialModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'email', objects, saveLinks: saveLinks);
  }
}

extension CredentialModelQueryWhereSort
    on QueryBuilder<CredentialModel, CredentialModel, QWhere> {
  QueryBuilder<CredentialModel, CredentialModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CredentialModelQueryWhere
    on QueryBuilder<CredentialModel, CredentialModel, QWhereClause> {
  QueryBuilder<CredentialModel, CredentialModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterWhereClause>
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

  QueryBuilder<CredentialModel, CredentialModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<CredentialModel, CredentialModel, QAfterWhereClause>
  emailEqualTo(String email) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'email', value: [email]),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterWhereClause>
  emailNotEqualTo(String email) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'email',
                lower: [],
                upper: [email],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'email',
                lower: [email],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'email',
                lower: [email],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'email',
                lower: [],
                upper: [email],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CredentialModelQueryFilter
    on QueryBuilder<CredentialModel, CredentialModel, QFilterCondition> {
  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'displayName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'email',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'email',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
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

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
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

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
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

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'passwordHash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'passwordHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'passwordHash',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'passwordHash', value: ''),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  passwordHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'passwordHash', value: ''),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension CredentialModelQueryObject
    on QueryBuilder<CredentialModel, CredentialModel, QFilterCondition> {
  QueryBuilder<CredentialModel, CredentialModel, QAfterFilterCondition> tenant(
    FilterQuery<TenantModel> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tenant');
    });
  }
}

extension CredentialModelQueryLinks
    on QueryBuilder<CredentialModel, CredentialModel, QFilterCondition> {}

extension CredentialModelQuerySortBy
    on QueryBuilder<CredentialModel, CredentialModel, QSortBy> {
  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  sortByPasswordHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  sortByPasswordHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.desc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension CredentialModelQuerySortThenBy
    on QueryBuilder<CredentialModel, CredentialModel, QSortThenBy> {
  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  thenByPasswordHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  thenByPasswordHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordHash', Sort.desc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension CredentialModelQueryWhereDistinct
    on QueryBuilder<CredentialModel, CredentialModel, QDistinct> {
  QueryBuilder<CredentialModel, CredentialModel, QDistinct>
  distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QDistinct> distinctByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QDistinct>
  distinctByPasswordHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CredentialModel, CredentialModel, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension CredentialModelQueryProperty
    on QueryBuilder<CredentialModel, CredentialModel, QQueryProperty> {
  QueryBuilder<CredentialModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CredentialModel, String, QQueryOperations>
  displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<CredentialModel, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<CredentialModel, String, QQueryOperations>
  passwordHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordHash');
    });
  }

  QueryBuilder<CredentialModel, TenantModel, QQueryOperations>
  tenantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenant');
    });
  }

  QueryBuilder<CredentialModel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
