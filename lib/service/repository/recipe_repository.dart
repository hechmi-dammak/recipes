import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/service/isar_service.dart';
import 'package:recipes/service/utils_service.dart';

class RecipeRepository extends GetxService {
  static RecipeRepository get find => Get.find<RecipeRepository>();

  Future<void> save(Recipe recipe) async {
    if (recipe.id == null) {
      recipe.name = await UtilsService.find.getUniqueName(
          recipe.name,
          (name) async => (await findAllByNameStartWith(recipe.name))
              .map((recipe) => recipe.name)
              .toSet());
    }
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipes.put(recipe);
      await recipe.picture.save();
      await recipe.category.save();
      await recipe.instructions.save();
      await recipe.ingredients.save();
    });
  }

  Future<Recipe?> findById(
    int? id, {
    withPicture = true,
  }) async {
    if (id == null) return null;
    return IsarService.isar.recipes.get(id);
  }

  Future<List<Recipe>> findAll() async {
    return await IsarService.isar.recipes.where().findAll();
  }

  Future<List<Recipe>> findAllByRecipeCategoryId(int? id) async {
    if (id == null) return [];
    return await IsarService.isar.recipes
        .filter()
        .category((queryBuilder) => queryBuilder.idEqualTo(id))
        .findAll();
  }

  Future<List<Recipe>> findAllByNameStartWith(String name) async {
    return await IsarService.isar.recipes
        .filter()
        .nameStartsWith(name)
        .findAll();
  }

  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    //todo delete instructions and ingredients
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.recipes.delete(id));
  }

//
// Future<int> deleteByRecipeCategoryId(int recipeCategoryId) async {
//   //todo: delete ingredients(only info not the element) and instructions
//   return await (await DataBaseProvider.database).delete(
//     tableRecipes,
//     where: '${RecipeFields.categoryId} = ?',
//     whereArgs: [recipeCategoryId],
//   );
// }

}
