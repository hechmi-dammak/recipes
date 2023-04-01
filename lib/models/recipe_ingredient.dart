import 'package:isar/isar.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/ingredient_category.dart';
import 'package:recipes/models/recipe.dart';

part 'recipe_ingredient.g.dart';

@collection
class RecipeIngredient {
  Id? id;

  //todo omitted for this iteration
  final IsarLink<IngredientCategory> category;
  final IsarLink<Ingredient> ingredient;
  @Backlink(to: 'ingredients')
  final IsarLink<Recipe> recipe;
  double? quantity;
  String? measuring;
  String? description;

  @ignore
  String? get amount {
    final amount =
        '${quantity == null ? '' : quantity.toString()} ${measuring ?? ''}'
            .trim();
    return amount.isEmpty ? null : amount;
  }

  String? getAmount(int servings, [int? recipeServings]) {
    String result = '';
    if (quantity != null) {
      final num resultQuantity =
          ((quantity! * servings) / (recipeServings ?? 1));
      if (resultQuantity % 1 == 0) {
        result += '${resultQuantity.toInt()} ';
      } else {
        result += '$resultQuantity ';
      }
    }
    if (measuring != null) {
      result += '${measuring!} ';
    }
    return result == '' ? null : result;
  }

  set amount(String? amount) {
    if (amount == null || amount.isEmpty) {
      quantity = null;
      measuring = null;
      return;
    }
    quantity = double.tryParse(amount.replaceAll(RegExp(r'[^0-9\\.]'), ''));
    measuring = amount.replaceAll(RegExp(r'[0-9\\.]'), '').trim();
  }

  RecipeIngredient({
    this.id,
    this.description,
    this.measuring,
    this.quantity,
    IsarLink<Ingredient>? ingredient,
    IsarLink<Recipe>? recipe,
    IsarLink<IngredientCategory>? category,
  })  : ingredient = ingredient ?? IsarLink<Ingredient>(),
        category = category ?? IsarLink<IngredientCategory>(),
        recipe = recipe ?? IsarLink<Recipe>();

  RecipeIngredient.fromCopy(RecipeIngredient recipeIngredient)
      : id = recipeIngredient.id,
        description = recipeIngredient.description,
        measuring = recipeIngredient.measuring,
        quantity = recipeIngredient.quantity,
        ingredient = recipeIngredient.ingredient,
        recipe = recipeIngredient.recipe,
        category = recipeIngredient.category;
}
