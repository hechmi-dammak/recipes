import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/repository/picture_repository.dart';
import 'package:recipes/service/isar_service.dart';

class RecipeCategoryRepository extends GetxService {
  static RecipeCategoryRepository get find =>
      Get.find<RecipeCategoryRepository>();

  Future<RecipeCategory> save(RecipeCategory recipeCategory) async {
    await _replaceWithSameName(recipeCategory);
    return await _save(recipeCategory);
  }

  Future<RecipeCategory> _save(RecipeCategory recipeCategory) async {
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
    if (recipeCategory.id == null) {
      final List<RecipeCategory> recipeCategories = await IsarService
          .isar.recipeCategories
          .filter()
          .nameEqualTo(recipeCategory.name, caseSensitive: false)
          .findAll();
      if (recipeCategories.isNotEmpty) {
        final RecipeCategory tmpRecipeCategory = recipeCategories.first;
        recipeCategory.id = tmpRecipeCategory.id;
        recipeCategory.description ??= tmpRecipeCategory.description;
        recipeCategory.picture.value ??= tmpRecipeCategory.picture.value;
      }
    }
  }

  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    //todo delete recipes
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.recipeCategories.delete(id));
  }

  Future<RecipeCategory?> findById(int? id) async {
    if (id == null) return null;
    return IsarService.isar.recipeCategories.get(id);
  }

  Future<List<RecipeCategory>> findAll() async {
    return await IsarService.isar.recipeCategories.where().findAll();
  }

  Future<List<RecipeCategory>> findAllByNameStartWith(String name) async {
    return await IsarService.isar.recipeCategories
        .filter()
        .nameStartsWith(name)
        .findAll();
  }
}
