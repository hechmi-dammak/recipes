// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recipe_ingredient.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetRecipeIngredientCollection on Isar {
  IsarCollection<RecipeIngredient> get recipeIngredients => this.collection();
}

const RecipeIngredientSchema = CollectionSchema(
  name: r'RecipeIngredient',
  id: -7135109042295776315,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'measuring': PropertySchema(
      id: 1,
      name: r'measuring',
      type: IsarType.string,
    ),
    r'quantity': PropertySchema(
      id: 2,
      name: r'quantity',
      type: IsarType.double,
    )
  },
  estimateSize: _recipeIngredientEstimateSize,
  serialize: _recipeIngredientSerialize,
  deserialize: _recipeIngredientDeserialize,
  deserializeProp: _recipeIngredientDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'category': LinkSchema(
      id: -2788489763125693975,
      name: r'category',
      target: r'IngredientCategory',
      single: true,
    ),
    r'ingredient': LinkSchema(
      id: 4177305036941936587,
      name: r'ingredient',
      target: r'Ingredient',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _recipeIngredientGetId,
  getLinks: _recipeIngredientGetLinks,
  attach: _recipeIngredientAttach,
  version: '3.0.5',
);

int _recipeIngredientEstimateSize(
  RecipeIngredient object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.measuring;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _recipeIngredientSerialize(
  RecipeIngredient object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeString(offsets[1], object.measuring);
  writer.writeDouble(offsets[2], object.quantity);
}

RecipeIngredient _recipeIngredientDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecipeIngredient();
  object.description = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.measuring = reader.readStringOrNull(offsets[1]);
  object.quantity = reader.readDoubleOrNull(offsets[2]);
  return object;
}

P _recipeIngredientDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recipeIngredientGetId(RecipeIngredient object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _recipeIngredientGetLinks(RecipeIngredient object) {
  return [object.category, object.ingredient];
}

void _recipeIngredientAttach(
    IsarCollection<dynamic> col, Id id, RecipeIngredient object) {
  object.id = id;
  object.category
      .attach(col, col.isar.collection<IngredientCategory>(), r'category', id);
  object.ingredient
      .attach(col, col.isar.collection<Ingredient>(), r'ingredient', id);
}

extension RecipeIngredientQueryWhereSort
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QWhere> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecipeIngredientQueryWhere
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QWhereClause> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause>
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterWhereClause> idBetween(
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
}

extension RecipeIngredientQueryFilter
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QFilterCondition> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'measuring',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'measuring',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measuring',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'measuring',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'measuring',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'measuring',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'measuring',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'measuring',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'measuring',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'measuring',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measuring',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      measuringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'measuring',
        value: '',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      quantityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'quantity',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      quantityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'quantity',
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      quantityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      quantityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      quantityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      quantityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension RecipeIngredientQueryObject
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QFilterCondition> {}

extension RecipeIngredientQueryLinks
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QFilterCondition> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      category(FilterQuery<IngredientCategory> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'category');
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'category', 0, true, 0, true);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      ingredient(FilterQuery<Ingredient> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'ingredient');
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterFilterCondition>
      ingredientIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'ingredient', 0, true, 0, true);
    });
  }
}

extension RecipeIngredientQuerySortBy
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QSortBy> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      sortByMeasuring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuring', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      sortByMeasuringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuring', Sort.desc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }
}

extension RecipeIngredientQuerySortThenBy
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QSortThenBy> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByMeasuring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuring', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByMeasuringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuring', Sort.desc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QAfterSortBy>
      thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }
}

extension RecipeIngredientQueryWhereDistinct
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QDistinct> {
  QueryBuilder<RecipeIngredient, RecipeIngredient, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QDistinct>
      distinctByMeasuring({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'measuring', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecipeIngredient, RecipeIngredient, QDistinct>
      distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }
}

extension RecipeIngredientQueryProperty
    on QueryBuilder<RecipeIngredient, RecipeIngredient, QQueryProperty> {
  QueryBuilder<RecipeIngredient, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecipeIngredient, String?, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<RecipeIngredient, String?, QQueryOperations>
      measuringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measuring');
    });
  }

  QueryBuilder<RecipeIngredient, double?, QQueryOperations> quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }
}
