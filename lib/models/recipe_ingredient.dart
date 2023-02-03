import 'package:isar/isar.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/ingredient_category.dart';

part 'recipe_ingredient.g.dart';

@collection
class RecipeIngredient {
  Id? id;
  final IsarLink<IngredientCategory> category;
  final IsarLink<Ingredient> ingredient;
  double? quantity;
  String? measuring;
  String? description;

  RecipeIngredient({
    this.id,
    this.description,
    this.measuring,
    this.quantity,
    IsarLink<Ingredient>? ingredient,
    IsarLink<IngredientCategory>? category,
  })  : ingredient = ingredient ?? IsarLink<Ingredient>(),
        category = category ?? IsarLink<IngredientCategory>();

  RecipeIngredient.fromCopy(RecipeIngredient recipeIngredient)
      : id = recipeIngredient.id,
        description = recipeIngredient.description,
        measuring = recipeIngredient.measuring,
        quantity = recipeIngredient.quantity,
        ingredient = recipeIngredient.ingredient,
        category = recipeIngredient.category;
}
