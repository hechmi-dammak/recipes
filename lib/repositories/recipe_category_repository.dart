import 'package:get/get.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/entities/recipe_category.dart';
import 'package:mekla/repositories/abstracts/repository_service_with_name.dart';
import 'package:mekla/repositories/picture_repository.dart';
import 'package:mekla/repositories/recipe_repository.dart';
import 'package:mekla/services/isar_service.dart';

class RecipeCategoryRepository
    extends RepositoryServiceWithName<RecipeCategory> {
  static RecipeCategoryRepository get find =>
      Get.find<RecipeCategoryRepository>();

  @override
  Future<RecipeCategory> save(RecipeCategory element) async {
    await replaceWithSameName(element);
    return await saveInternal(element);
  }

  @override
  Future<RecipeCategory> saveInternal(RecipeCategory element) async {
    element.name = element.name.trim();
    element.description = element.description?.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipeCategories.put(element);
    });
    if (element.picture.value != null && element.picture.value?.id == null) {
      await PictureRepository.find.save(element.picture.value!);
    }
    await IsarService.isar.writeTxn(() async {
      await element.picture.save();
    });

    return element;
  }

  @override
  Future<bool> beforeDelete(int id) async {
    await RecipeRepository.find.deleteByRecipeCategoryId(id);
    return true;
  }

  @override
  Future<void> replaceOriginalItemValues(
      RecipeCategory original, RecipeCategory tmp) async {
    original.picture.value ??= tmp.picture.value;
    original.description ??= tmp.description;
  }

  @override
  Future<void> replaceTmpItemValues(
      RecipeCategory original, RecipeCategory tmp) async {
    final List<Recipe> recipes =
        await RecipeRepository.find.findAllByRecipeCategoryId(original.id);

    await IsarService.isar.writeTxn(() async {
      for (Recipe recipe in recipes) {
        recipe.category.value = tmp;
        recipe.category.save();
      }
    });
    tmp.picture.value = original.picture.value ?? tmp.picture.value;
    tmp.description = original.description ?? tmp.description;
  }
}
