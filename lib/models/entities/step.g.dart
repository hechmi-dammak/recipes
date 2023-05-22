// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStepCollection on Isar {
  IsarCollection<Step> get steps => this.collection();
}

const StepSchema = CollectionSchema(
  name: r'Step',
  id: 5530288897656118150,
  properties: {
    r'instruction': PropertySchema(
      id: 0,
      name: r'instruction',
      type: IsarType.string,
    )
  },
  estimateSize: _stepEstimateSize,
  serialize: _stepSerialize,
  deserialize: _stepDeserialize,
  deserializeProp: _stepDeserializeProp,
  idName: r'id',
  indexes: {
    r'instruction': IndexSchema(
      id: 1534773907639968272,
      name: r'instruction',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'instruction',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'picture': LinkSchema(
      id: -6648206405154287265,
      name: r'picture',
      target: r'Picture',
      single: true,
    ),
    r'recipe': LinkSchema(
      id: 8111099506753257848,
      name: r'recipe',
      target: r'Recipe',
      single: true,
      linkName: r'steps',
    )
  },
  embeddedSchemas: {},
  getId: _stepGetId,
  getLinks: _stepGetLinks,
  attach: _stepAttach,
  version: '3.1.0+1',
);

int _stepEstimateSize(
  Step object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.instruction.length * 3;
  return bytesCount;
}

void _stepSerialize(
  Step object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.instruction);
}

Step _stepDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Step(
    id: id,
    instruction: reader.readStringOrNull(offsets[0]) ?? '',
  );
  return object;
}

P _stepDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stepGetId(Step object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _stepGetLinks(Step object) {
  return [object.picture, object.recipe];
}

void _stepAttach(IsarCollection<dynamic> col, Id id, Step object) {
  object.id = id;
  object.picture.attach(col, col.isar.collection<Picture>(), r'picture', id);
  object.recipe.attach(col, col.isar.collection<Recipe>(), r'recipe', id);
}

extension StepQueryWhereSort on QueryBuilder<Step, Step, QWhere> {
  QueryBuilder<Step, Step, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StepQueryWhere on QueryBuilder<Step, Step, QWhereClause> {
  QueryBuilder<Step, Step, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Step, Step, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Step, Step, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Step, Step, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterWhereClause> instructionEqualTo(
      String instruction) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'instruction',
        value: [instruction],
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterWhereClause> instructionNotEqualTo(
      String instruction) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'instruction',
              lower: [],
              upper: [instruction],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'instruction',
              lower: [instruction],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'instruction',
              lower: [instruction],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'instruction',
              lower: [],
              upper: [instruction],
              includeUpper: false,
            ));
      }
    });
  }
}

extension StepQueryFilter on QueryBuilder<Step, Step, QFilterCondition> {
  QueryBuilder<Step, Step, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'instruction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'instruction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'instruction',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instruction',
        value: '',
      ));
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> instructionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'instruction',
        value: '',
      ));
    });
  }
}

extension StepQueryObject on QueryBuilder<Step, Step, QFilterCondition> {}

extension StepQueryLinks on QueryBuilder<Step, Step, QFilterCondition> {
  QueryBuilder<Step, Step, QAfterFilterCondition> picture(
      FilterQuery<Picture> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'picture');
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> pictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'picture', 0, true, 0, true);
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> recipe(
      FilterQuery<Recipe> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'recipe');
    });
  }

  QueryBuilder<Step, Step, QAfterFilterCondition> recipeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'recipe', 0, true, 0, true);
    });
  }
}

extension StepQuerySortBy on QueryBuilder<Step, Step, QSortBy> {
  QueryBuilder<Step, Step, QAfterSortBy> sortByInstruction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instruction', Sort.asc);
    });
  }

  QueryBuilder<Step, Step, QAfterSortBy> sortByInstructionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instruction', Sort.desc);
    });
  }
}

extension StepQuerySortThenBy on QueryBuilder<Step, Step, QSortThenBy> {
  QueryBuilder<Step, Step, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Step, Step, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Step, Step, QAfterSortBy> thenByInstruction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instruction', Sort.asc);
    });
  }

  QueryBuilder<Step, Step, QAfterSortBy> thenByInstructionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instruction', Sort.desc);
    });
  }
}

extension StepQueryWhereDistinct on QueryBuilder<Step, Step, QDistinct> {
  QueryBuilder<Step, Step, QDistinct> distinctByInstruction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'instruction', caseSensitive: caseSensitive);
    });
  }
}

extension StepQueryProperty on QueryBuilder<Step, Step, QQueryProperty> {
  QueryBuilder<Step, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Step, String, QQueryOperations> instructionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'instruction');
    });
  }
}
