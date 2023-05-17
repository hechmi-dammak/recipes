import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/recipe.dart';
import 'package:mekla/models/isar_models/recipe_category.dart';
import 'package:mekla/repository/picture_repository.dart';
import 'package:mekla/repository/recipe_category_repository.dart';
import 'package:mekla/repository/recipe_ingredient_repository.dart';
import 'package:mekla/repository/repository_service.dart';
import 'package:mekla/repository/step_repository.dart';
import 'package:mekla/service/isar_service.dart';
import 'package:mekla/service/utils_service.dart';

class RecipeRepository extends RepositoryService<Recipe> {
  static RecipeRepository get find => Get.find<RecipeRepository>();
  @override
  Future<Recipe> save(Recipe element) async {
    await _setUniqueName(element);
    return await _save(element);
  }

  Future<Recipe> _save(Recipe recipe) async {
    recipe.name = recipe.name.trim();
    recipe.description = recipe.description?.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipes.put(recipe);
    });

    if (recipe.picture.value != null && recipe.picture.value?.id == null) {
      await PictureRepository.find.save(recipe.picture.value!);
    }
    if (recipe.category.value != null && recipe.category.value?.id == null) {
      await RecipeCategoryRepository.find.save(recipe.category.value!);
    }
    await IsarService.isar.writeTxn(() async {
      await recipe.picture.save();
      await recipe.category.save();
      await recipe.steps.save();
      await recipe.ingredients.save();
    });
    return recipe;
  }

  Future<void> _setUniqueName(Recipe recipe) async {
    if (recipe.id == null) {
      recipe.name = await UtilsService.find.getUniqueName(
          recipe.name,
              (name) async =>
              (await findAllByNameStartWith(recipe.name))
                  .map((recipe) => recipe.name)
                  .toSet());
    }
  }

  Future<List<Recipe>> findAllByRecipeCategoryId(int? id) async {
    if (id == null) return [];
    return await IsarService.isar.recipes
        .filter()
        .category((queryBuilder) => queryBuilder.idEqualTo(id))
        .findAll();
  }

  Future<List<Recipe>> findAllByNameStartWith(String name) async {
    return await IsarService.isar.recipes
        .filter()
        .nameStartsWith(name)
        .findAll();
  }


  Future<int> deleteByRecipeCategoryId(int recipeCategoryId) async {
    final List<Recipe> recipes = await findAllByRecipeCategoryId(
        recipeCategoryId);

    for (var recipe in recipes) {
      deleteById(recipe.id);
    }
    return recipes.length;
  }

  @override
  Future<bool> beforeDelete(int id) async {
    await StepRepository.find.deleteByRecipeId(id);
    await RecipeIngredientRepository.find.deleteByRecipeId(id);
    return true;
  }
}
