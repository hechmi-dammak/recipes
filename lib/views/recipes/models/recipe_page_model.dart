import 'package:recipes/models/recipe.dart';

class RecipePageModel extends Recipe {
  bool selected = false;

  RecipePageModel({this.selected = false, required Recipe recipe})
      : super.fromCopy(recipe);
}
