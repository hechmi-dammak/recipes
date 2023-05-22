import 'package:isar/isar.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/models/entities/picture.dart';
import 'package:mekla/models/entities/recipe_category.dart';
import 'package:mekla/models/entities/recipe_ingredient.dart';
import 'package:mekla/models/entities/step.dart';
import 'package:mekla/models/interfaces/model_name.dart';
import 'package:mekla/models/interfaces/model_picture.dart';
import 'package:mekla/repositories/recipe_ingredient_repository.dart';
import 'package:mekla/repositories/step_repository.dart';

part 'recipe.g.dart';

@collection
class Recipe implements ModelName, ModelPicture {
  @override
  Id? id;
  @override
  @Index()
  String name;
  String? description;
  final IsarLink<RecipeCategory> category;
  int servings;
  final IsarLinks<Step> steps;
  final IsarLinks<RecipeIngredient> ingredients;
  @override
  final IsarLink<Picture> picture;

  Recipe({
    this.id,
    this.name = '',
    this.description,
    IsarLink<RecipeCategory>? category,
    this.servings = Constants.defaultServings,
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

  Map<String, dynamic> toMap([bool withId = true]) {
    return {
      if (withId) 'id': id,
      'name': name,
      'description': description,
      'category': category.value?.toMap(withId),
      'servings': servings,
      'steps': steps.map((step) => step.toMap(withId)).toList(),
      'ingredients':
          ingredients.map((ingredient) => ingredient.toMap(withId)).toList(),
      'picture': picture.value?.toMap(withId),
    };
  }

  static Future<Recipe> fromMap(Map<String, dynamic> map) async {
    final recipe = Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      servings: map['servings'],
    );
    if (map['ingredients'] != null) {
      for (var item in map['ingredients'] as List) {
        final ingredient = RecipeIngredient.fromMap(item);
        await RecipeIngredientRepository.find.save(ingredient);
        recipe.ingredients.add(ingredient);
      }
    }
    if (map['steps'] != null) {
      for (var item in map['steps'] as List) {
        final step = Step.fromMap(item);
        await StepRepository.find.save(step);
        recipe.steps.add(step);
      }
    }
    if (map['category'] != null) {
      recipe.category.value = RecipeCategory.fromMap(map['category']);
    }
    if (map['picture'] != null) {
      recipe.picture.value = Picture.fromMap(map['picture']);
    }
    return recipe;
  }
}
