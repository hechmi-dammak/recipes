import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/service/isar_service.dart';
import 'package:recipes/service/utils_service.dart';

class RecipeCategoryRepository extends GetxService {
  static RecipeCategoryRepository get find =>
      Get.find<RecipeCategoryRepository>();

  Future<void> save(RecipeCategory recipeCategory) async {
    if (recipeCategory.id == null) {
      recipeCategory.name = await UtilsService.find.getUniqueName(
          recipeCategory.name,
          (name) async => (await findAllByNameStartWith(recipeCategory.name))
              .map((recipeCategory) => recipeCategory.name)
              .toSet());
    }
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipeCategories.put(recipeCategory);
      await recipeCategory.picture.save();
    });
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
