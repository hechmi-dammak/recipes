import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/ingredient.dart';
import 'package:mekla/models/isar_models/recipe.dart';
import 'package:mekla/models/isar_models/recipe_ingredient.dart';
import 'package:mekla/repository/ingredient_category_repository.dart';
import 'package:mekla/repository/ingredient_repository.dart';
import 'package:mekla/repository/recipe_repository.dart';
import 'package:mekla/service/isar_service.dart';

class RecipeIngredientRepository extends GetxService {
  static RecipeIngredientRepository get find =>
      Get.find<RecipeIngredientRepository>();

  Future<RecipeIngredient> save(RecipeIngredient recipeIngredient) async {
    recipeIngredient.description = recipeIngredient.description?.trim();
    recipeIngredient.measuring = recipeIngredient.measuring?.trim();
    await IsarService.isar.writeTxn(() async =>
        await IsarService.isar.recipeIngredients.put(recipeIngredient));

    if (recipeIngredient.category.value != null &&
        recipeIngredient.category.value?.id == null) {
      await IngredientCategoryRepository.find
          .save(recipeIngredient.category.value!);
    }
    if (recipeIngredient.ingredient.value != null &&
        recipeIngredient.ingredient.value?.id == null) {
      await IngredientRepository.find.save(recipeIngredient.ingredient.value!);
    }

    if (recipeIngredient.recipe.value != null &&
        recipeIngredient.recipe.value?.id == null) {
      await RecipeRepository.find.save(recipeIngredient.recipe.value!);
    }
    await IsarService.isar.writeTxn(() async {
      await recipeIngredient.category.save();
      await recipeIngredient.ingredient.save();
      await recipeIngredient.recipe.save();
    });

    return recipeIngredient;
  }

  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.recipeIngredients.delete(id));
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

  Future<RecipeIngredient?> findById(int? id) async {
    if (id == null) return null;
    return IsarService.isar.recipeIngredients.get(id);
  }

  Future<List<RecipeIngredient>> findAll() async {
    return await IsarService.isar.recipeIngredients.where().findAll();
  }
}
