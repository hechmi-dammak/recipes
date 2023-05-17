import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/recipe.dart';
import 'package:mekla/models/isar_models/recipe_category.dart';
import 'package:mekla/repository/picture_repository.dart';
import 'package:mekla/repository/recipe_repository.dart';
import 'package:mekla/repository/repository_service.dart';
import 'package:mekla/service/isar_service.dart';

class RecipeCategoryRepository extends RepositoryService<RecipeCategory> {
  static RecipeCategoryRepository get find =>
      Get.find<RecipeCategoryRepository>();

  @override
  Future<RecipeCategory> save(RecipeCategory element) async {
    await _replaceWithSameName(element);
    return await _save(element);
  }

  Future<RecipeCategory> _save(RecipeCategory recipeCategory) async {
    recipeCategory.name = recipeCategory.name.trim();
    recipeCategory.description = recipeCategory.description?.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipeCategories.put(recipeCategory);
    });
    if (recipeCategory.picture.value != null &&
        recipeCategory.picture.value?.id == null) {
      await PictureRepository.find.save(recipeCategory.picture.value!);
    }
    await IsarService.isar.writeTxn(() async {
      await recipeCategory.picture.save();
    });

    return recipeCategory;
  }

  Future<void> _replaceWithSameName(RecipeCategory recipeCategory) async {
    final List<RecipeCategory> recipeCategories = await IsarService
        .isar.recipeCategories
        .filter()
        .nameEqualTo(recipeCategory.name.trim(), caseSensitive: false)
        .findAll();
    if (recipeCategories.isNotEmpty) {
      final RecipeCategory tmpRecipeCategory = recipeCategories.first;
      if (recipeCategory.id != null) {
        final List<Recipe> recipes = await RecipeRepository.find
            .findAllByRecipeCategoryId(recipeCategory.id);

        await IsarService.isar.writeTxn(() async {
          for (Recipe recipe in recipes) {
            recipe.category.value = tmpRecipeCategory;
            recipe.category.save();
          }
        });
        tmpRecipeCategory.picture.value =
            recipeCategory.picture.value ?? tmpRecipeCategory.picture.value;
        tmpRecipeCategory.description =
            recipeCategory.description ?? tmpRecipeCategory.description;
        _save(tmpRecipeCategory);
        deleteById(recipeCategory.id);
      }
      recipeCategory.id = tmpRecipeCategory.id;
      recipeCategory.picture.value ??= tmpRecipeCategory.picture.value;
      recipeCategory.description ??= tmpRecipeCategory.description;
    }
  }

  Future<List<RecipeCategory>> findAllByNameStartWith(String name) async {
    return await IsarService.isar.recipeCategories
        .filter()
        .nameStartsWith(name)
        .findAll();
  }

  @override
  Future<bool> beforeDelete(int id) async {
    await RecipeRepository.find.deleteByRecipeCategoryId(id);
    return true;
  }
}
