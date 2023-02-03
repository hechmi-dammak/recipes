import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/recipe_ingredient.dart';
import 'package:recipes/service/isar_service.dart';

class RecipeIngredientRepository extends GetxService {
  static RecipeIngredientRepository get find =>
      Get.find<RecipeIngredientRepository>();

  Future<RecipeIngredient> save(RecipeIngredient recipeIngredient) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipeIngredients.put(recipeIngredient);
      await recipeIngredient.category.save();
      await recipeIngredient.ingredient.save();
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
