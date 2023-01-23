import 'package:isar/isar.dart';

part 'ingredient_category.g.dart';

@Collection(accessor: 'ingredientCategories')
class IngredientCategory {
  Id? id;
  @Index()
  String name;

  IngredientCategory({this.name = ''});
}
