import 'package:recipes/models/recipe.dart';

class RecipePMRecipes extends Recipe {
  bool selected;

  RecipePMRecipes({this.selected = false, required Recipe recipe})
      : super.fromCopy(recipe);
}
