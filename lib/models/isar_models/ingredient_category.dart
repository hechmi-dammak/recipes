import 'package:isar/isar.dart';

part 'ingredient_category.g.dart';

@Collection(accessor: 'ingredientCategories')
class IngredientCategory {
  Id? id;
  @Index()
  String name;

  IngredientCategory({this.id, this.name = ''});

  Map<String, dynamic> toMap([bool withId = true]) {
    return {
      if (withId) 'id': id,
      'name': name,
    };
  }

  factory IngredientCategory.fromMap(Map<String, dynamic> map) {
    return IngredientCategory(
      id: map['id'],
      name: map['name'],
    );
  }
}
