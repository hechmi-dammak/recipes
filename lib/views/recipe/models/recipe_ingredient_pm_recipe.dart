import 'package:recipes/models/recipe_ingredient.dart';

class RecipeIngredientPMRecipe extends RecipeIngredient {
  bool selected;
  bool used;

  RecipeIngredientPMRecipe(
      {this.selected = false,
      this.used = false,
      required RecipeIngredient recipeIngredient})
      : super.fromCopy(recipeIngredient);
}
