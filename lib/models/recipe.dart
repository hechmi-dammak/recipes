import 'package:isar/isar.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/models/recipe_ingredient.dart';

part 'recipe.g.dart';

@collection
class Recipe {
  Id? id;
  @Index()
  String name;
  String? description;
  final IsarLink<RecipeCategory> category;
  int servings;
  final IsarLinks<Instruction> instructions;
  final IsarLinks<RecipeIngredient> ingredients;
  final IsarLink<Picture> picture;

  Recipe({
    this.id,
    this.name = '',
    this.description,
    IsarLink<RecipeCategory>? category,
    this.servings = 4,
    IsarLinks<RecipeIngredient>? ingredients,
    IsarLinks<Instruction>? instructions,
    IsarLink<Picture>? picture,
  })  : category = category ?? IsarLink<RecipeCategory>(),
        ingredients = ingredients ?? IsarLinks<RecipeIngredient>(),
        instructions = instructions ?? IsarLinks<Instruction>(),
        picture = picture ?? IsarLink<Picture>();

  Recipe.fromCopy(Recipe recipe)
      : id = recipe.id,
        name = recipe.name,
        description = recipe.description,
        servings = recipe.servings,
        category = recipe.category,
        ingredients = recipe.ingredients,
        instructions = recipe.instructions,
        picture = recipe.picture;
}
