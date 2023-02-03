import 'package:recipes/models/recipe_category.dart';

class RecipeCategoryPMRecipeCategories extends RecipeCategory {
  bool selected;

  RecipeCategoryPMRecipeCategories(
      {this.selected = false, required RecipeCategory recipeCategory})
      : super.fromCopy(recipeCategory);
}
