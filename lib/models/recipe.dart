import 'package:isar/isar.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/models/recipe_ingredient.dart';
import 'package:recipes/models/step.dart';

part 'recipe.g.dart';

@collection
class Recipe {
  Id? id;
  @Index()
  String name;
  String? description;

  //todo omitted for this iteration
  final IsarLink<RecipeCategory> category;
  int servings;
  final IsarLinks<Step> steps;
  final IsarLinks<RecipeIngredient> ingredients;
  final IsarLink<Picture> picture;

  Recipe({
    this.id,
    this.name = '',
    this.description,
    IsarLink<RecipeCategory>? category,
    this.servings = 4,
    IsarLinks<RecipeIngredient>? ingredients,
    IsarLinks<Step>? steps,
    IsarLink<Picture>? picture,
  })  : category = category ?? IsarLink<RecipeCategory>(),
        ingredients = ingredients ?? IsarLinks<RecipeIngredient>(),
        steps = steps ?? IsarLinks<Step>(),
        picture = picture ?? IsarLink<Picture>();

  Recipe.fromCopy(Recipe recipe)
      : id = recipe.id,
        name = recipe.name,
        description = recipe.description,
        servings = recipe.servings,
        category = recipe.category,
        ingredients = recipe.ingredients,
        steps = recipe.steps,
        picture = recipe.picture;
}
