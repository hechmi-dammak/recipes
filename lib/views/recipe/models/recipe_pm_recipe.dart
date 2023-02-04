import 'package:recipes/models/recipe.dart';

class RecipePMRecipe extends Recipe {
  bool selected;

  RecipePMRecipe({this.selected = false, required Recipe recipe})
      : super.fromCopy(recipe);
}
