import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/service/isar_service.dart';

class RecipeCategoryRepository extends GetxService {
  static RecipeCategoryRepository get find =>
      Get.find<RecipeCategoryRepository>();

  Future<void> save(RecipeCategory recipeCategory) async {
    if (recipeCategory.id == null) {
      await _setUniqueName(recipeCategory);
    }
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipeCategories.put(recipeCategory);
      await recipeCategory.picture.save();
    });
  }

  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.recipeCategories.delete(id));
  }

  //
  // Future<int> deleteByIdsIn(List<int?> ids) async {
  //   final idsNotNull = ids.toList();
  //   idsNotNull.removeWhere((element) => element == null);
  //   await RecipeRepository.find.deleteByRecipeCategoryIdsIn(ids);
  //   return await (await DataBaseProvider.database).delete(
  //     tableRecipesCategories,
  //     where: '${RecipeCategoryFields.id} in (?)',
  //     whereArgs: [idsNotNull],
  //   );
  // }

  Future<RecipeCategory?> findById(
    int? id, {
    withPicture = true,
  }) async {
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

  Future<void> _setUniqueName(RecipeCategory recipeCategory) async {
    final setOfNames = (await findAllByNameStartWith(recipeCategory.name))
        .map((recipeCategory) => recipeCategory.name)
        .toSet();
    if (!setOfNames.contains(recipeCategory.name)) return;
    var index = 1;
    while (true) {
      if (setOfNames.contains('${recipeCategory.name}_$index')) {
        index++;
      } else {
        recipeCategory.name += '_$index';
        break;
      }
    }
  }
}
