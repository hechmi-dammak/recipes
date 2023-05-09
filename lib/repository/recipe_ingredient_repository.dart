import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/recipe_ingredient.dart';
import 'package:recipes/repository/ingredient_category_repository.dart';
import 'package:recipes/repository/ingredient_repository.dart';
import 'package:recipes/repository/recipe_repository.dart';
import 'package:recipes/service/isar_service.dart';

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

  Future<RecipeIngredient?> findById(int? id) async {
    if (id == null) return null;
    return IsarService.isar.recipeIngredients.get(id);
  }

  Future<List<RecipeIngredient>> findAll() async {
    return await IsarService.isar.recipeIngredients.where().findAll();
  }
}
