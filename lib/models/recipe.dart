import 'package:isar/isar.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/models/recipe_ingredient.dart';

part 'generated/recipe.g.dart';

@collection
class Recipe {
  Id? id;
  @Index()
  String name;
  final category = IsarLink<RecipeCategory>();
  int servings;
  final instructions = IsarLinks<Instruction>();
  final ingredients = IsarLinks<RecipeIngredient>();
  final picture = IsarLink<Picture>();

  Recipe({
    this.name = '',
    this.servings = 4,
  });
}
