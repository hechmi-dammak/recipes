import 'package:get/get.dart';
import 'package:mekla/models/entities/ingredient_category.dart';
import 'package:mekla/models/entities/recipe_ingredient.dart';
import 'package:mekla/repositories/abstracts/repository_service_with_name.dart';
import 'package:mekla/repositories/recipe_ingredient_repository.dart';
import 'package:mekla/services/isar_service.dart';

class IngredientCategoryRepository
    extends RepositoryServiceWithName<IngredientCategory> {
  static IngredientCategoryRepository get find =>
      Get.find<IngredientCategoryRepository>();

  @override
  Future<IngredientCategory> save(IngredientCategory element) async {
    await replaceWithSameName(element);
    return await saveInternal(element);
  }

  @override
  Future<IngredientCategory> saveInternal(IngredientCategory element) async {
    element.name = element.name.trim();
    await IsarService.isar.writeTxn(
        () async => await IsarService.isar.ingredientCategories.put(element));
    return element;
  }

  @override
  Future<void> replaceOriginalItemValues(
      IngredientCategory original, IngredientCategory tmp) async {
    original.picture.value ??= tmp.picture.value;
  }

  @override
  Future<void> replaceTmpItemValues(
      IngredientCategory original, IngredientCategory tmp) async {
    final List<RecipeIngredient> recipeIngredients =
        await RecipeIngredientRepository()
            .findAllByIngredientCategoryId(original.id);
    await IsarService.isar.writeTxn(() async {
      for (RecipeIngredient recipeIngredient in recipeIngredients) {
        recipeIngredient.category.value = tmp;
        await recipeIngredient.category.save();
      }
    });
    tmp.picture.value = original.picture.value ?? tmp.picture.value;
  }
}
