import 'package:mekla/models/recipe.dart';
import 'package:mekla/views/recipe/models/recipe_ingredient_pm_recipe.dart';
import 'package:mekla/views/recipe/models/step_pm_recipe.dart';

class RecipePMRecipe extends Recipe {
  bool selected;
  List<RecipeIngredientPMRecipe> ingredientList = [];
  List<StepPMRecipe> stepList = [];

  RecipePMRecipe({this.selected = false, required Recipe recipe})
      : super.fromCopy(recipe) {
    ingredientList = recipe.ingredients
        .toList()
        .map((recipeIngredient) =>
            RecipeIngredientPMRecipe(recipeIngredient: recipeIngredient))
        .toList();
    stepList = recipe.steps
        .toList()
        .asMap()
        .entries
        .map((entry) => StepPMRecipe(order: entry.key + 1, step: entry.value))
        .toList();
  }
}
