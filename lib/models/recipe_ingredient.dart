import 'package:isar/isar.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/ingredient_category.dart';

part 'generated/recipe_ingredient.g.dart';

@collection
class RecipeIngredient {
  Id? id;
  final category = IsarLink<IngredientCategory>();
  final ingredient = IsarLink<Ingredient>();
  double? quantity;
  String? measuring;
  String? description;
}
