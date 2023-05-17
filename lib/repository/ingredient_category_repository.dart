import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/ingredient_category.dart';
import 'package:mekla/models/isar_models/recipe_ingredient.dart';
import 'package:mekla/repository/recipe_ingredient_repository.dart';
import 'package:mekla/repository/repository_service.dart';
import 'package:mekla/service/isar_service.dart';

class IngredientCategoryRepository
    extends RepositoryService<IngredientCategory> {
  static IngredientCategoryRepository get find =>
      Get.find<IngredientCategoryRepository>();

  @override
  Future<IngredientCategory> save(IngredientCategory element) async {
    await _replaceWithSameName(element);
    return await _save(element);
  }

  Future<IngredientCategory> _save(
      IngredientCategory ingredientCategory) async {
    ingredientCategory.name = ingredientCategory.name.trim();
    await IsarService.isar.writeTxn(() async =>
        await IsarService.isar.ingredientCategories.put(ingredientCategory));
    return ingredientCategory;
  }

  Future<void> _replaceWithSameName(
      IngredientCategory ingredientCategory) async {
    final List<IngredientCategory> ingredientCategories = await IsarService
        .isar.ingredientCategories
        .filter()
        .nameEqualTo(ingredientCategory.name.trim(), caseSensitive: false)
        .findAll();
    if (ingredientCategories.isNotEmpty) {
      final IngredientCategory tmpIngredientCategory =
          ingredientCategories.first;
      if (ingredientCategory.id != null) {
        final List<RecipeIngredient> recipeIngredients =
            await RecipeIngredientRepository()
                .findAllByIngredientCategoryId(ingredientCategory.id);
        await IsarService.isar.writeTxn(() async {
          for (RecipeIngredient recipeIngredient in recipeIngredients) {
            recipeIngredient.category.value = tmpIngredientCategory;
            recipeIngredient.category.save();
          }
        });
        tmpIngredientCategory.picture.value =
            ingredientCategory.picture.value ??
                tmpIngredientCategory.picture.value;
        _save(tmpIngredientCategory);
        deleteById(ingredientCategory.id);
      }
      ingredientCategory.id = tmpIngredientCategory.id;
      ingredientCategory.picture.value ??= tmpIngredientCategory.picture.value;
    }
  }

  Future<List<IngredientCategory>> findAllByNameStartWith(String name) async {
    return await IsarService.isar.ingredientCategories
        .filter()
        .nameStartsWith(name)
        .findAll();
  }
}
