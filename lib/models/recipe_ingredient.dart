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

  String? getAmount(int servings) {
    String result = '';
    if (quantity != null) {
      final double resultQuantity =
          ((quantity! * servings) / (recipe.value?.servings ?? 1));
      if (resultQuantity.truncateToDouble() == resultQuantity) {
        result += '${resultQuantity.toInt()} ';
      } else {
        result += '${double.parse(resultQuantity.toStringAsFixed(2))} ';
      }
    }
    if (measuring != null) {
      result += '${measuring!} ';
    }
    result = result.trim();
    return result == '' ? null : result;
  }

  void setAmount(String? amount, int servings) {
    if (amount == null || amount.isEmpty) {
      quantity = null;
      measuring = null;
      return;
    }
    quantity = double.tryParse(amount.replaceAll(RegExp(r'[^0-9\\.]'), ''));
    if (quantity != null) {
      quantity = ((quantity! * (recipe.value?.servings ?? 1)) / servings);
    }
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

  Map<String, dynamic> toMap([bool withId = true]) {
    return {
      if (withId) 'id': id,
      'category': category.value?.toMap(withId),
      'ingredient': ingredient.value?.toMap(withId),
      'quantity': quantity,
      'measuring': measuring,
      'description': description,
    };
  }

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    final recipeIngredient = RecipeIngredient(
      id: map['id'],
      quantity: map['quantity'],
      measuring: map['measuring'],
      description: map['description'],
    );
    if (map['category'] != null) {
      recipeIngredient.category.value =
          IngredientCategory.fromMap(map['category']);
    }
    if (map['ingredient'] != null) {
      recipeIngredient.ingredient.value = Ingredient.fromMap(map['ingredient']);
    }
    return recipeIngredient;
  }
}
