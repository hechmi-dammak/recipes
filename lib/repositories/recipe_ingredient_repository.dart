import 'package:get/get.dart';
import 'package:mekla/models/entities/ingredient.dart';
import 'package:mekla/models/entities/ingredient_category.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/entities/recipe_ingredient.dart';
import 'package:mekla/repositories/abstracts/repository_service.dart';
import 'package:mekla/repositories/ingredient_category_repository.dart';
import 'package:mekla/repositories/ingredient_repository.dart';
import 'package:mekla/repositories/recipe_repository.dart';
import 'package:mekla/services/isar_service.dart';

class RecipeIngredientRepository extends RepositoryService<RecipeIngredient> {
  static RecipeIngredientRepository get find =>
      Get.find<RecipeIngredientRepository>();

  @override
  Future<RecipeIngredient> save(RecipeIngredient element) async {
    return await saveInternal(element);
  }

  @override
  Future<RecipeIngredient> saveInternal(RecipeIngredient element) async {
    element.description = element.description?.trim();
    element.measuring = element.measuring?.trim();
    await IsarService.isar.writeTxn(
        () async => await IsarService.isar.recipeIngredients.put(element));

    if (element.category.value != null && element.category.value?.id == null) {
      await IngredientCategoryRepository.find.save(element.category.value!);
    }
    if (element.ingredient.value != null &&
        element.ingredient.value?.id == null) {
      await IngredientRepository.find.save(element.ingredient.value!);
    }

    if (element.recipe.value != null && element.recipe.value?.id == null) {
      await RecipeRepository.find.save(element.recipe.value!);
    }
    await IsarService.isar.writeTxn(() async {
      await element.category.save();
      await element.ingredient.save();
      await element.recipe.save();
    });

    return element;
  }

  Future<int> deleteByRecipeId(int recipeId) async {
    final List<RecipeIngredient> recipeIngredients = await IsarService
        .isar.recipeIngredients
        .filter()
        .recipe((recipe) => recipe.idEqualTo(recipeId))
        .findAll();
    for (var recipeIngredient in recipeIngredients) {
      deleteById(recipeIngredient.id);
    }
    return recipeIngredients.length;
  }

  Future<int> deleteByIngredientId(int ingredientId) async {
    final List<RecipeIngredient> recipeIngredients = await IsarService
        .isar.recipeIngredients
        .filter()
        .ingredient((ingredient) => ingredient.idEqualTo(ingredientId))
        .findAll();
    for (var recipeIngredient in recipeIngredients) {
      deleteById(recipeIngredient.id);
    }
    return recipeIngredients.length;
  }

  Future<List<RecipeIngredient>> findAllByIngredientCategoryId(int? id) async {
    if (id == null) return [];
    return await IsarService.isar.recipeIngredients
        .filter()
        .category((queryBuilder) => queryBuilder.idEqualTo(id))
        .findAll();
  }
}
