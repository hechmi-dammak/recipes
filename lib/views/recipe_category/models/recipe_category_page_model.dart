import 'package:recipes/models/recipe_category.dart';

class RecipeCategoryPageModel extends RecipeCategory {
  bool selected = false;

  RecipeCategoryPageModel(
      {this.selected = false, required RecipeCategory recipeCategory})
      : super.fromCopy(recipeCategory);
}
