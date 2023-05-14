import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/recipe.dart';
import 'package:mekla/models/isar_models/recipe_category.dart';
import 'package:mekla/repository/picture_repository.dart';
import 'package:mekla/repository/recipe_category_repository.dart';
import 'package:mekla/service/isar_service.dart';
import 'package:mekla/service/utils_service.dart';

class RecipeRepository extends GetxService {
  static RecipeRepository get find => Get.find<RecipeRepository>();

  Future<Recipe> save(Recipe recipe) async {
    await _setUniqueName(recipe);
    return await _save(recipe);
  }

  Future<Recipe> _save(Recipe recipe) async {
    recipe.name = recipe.name.trim();
    recipe.description = recipe.description?.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipes.put(recipe);
    });

    if (recipe.picture.value != null && recipe.picture.value?.id == null) {
      await PictureRepository.find.save(recipe.picture.value!);
    }
    if (recipe.category.value != null && recipe.category.value?.id == null) {
      await RecipeCategoryRepository.find.save(recipe.category.value!);
    }
    await IsarService.isar.writeTxn(() async {
      await recipe.picture.save();
      await recipe.category.save();
      await recipe.steps.save();
      await recipe.ingredients.save();
    });
    return recipe;
  }

  Future<void> _setUniqueName(Recipe recipe) async {
    if (recipe.id == null) {
      recipe.name = await UtilsService.find.getUniqueName(
          recipe.name,
          (name) async => (await findAllByNameStartWith(recipe.name))
              .map((recipe) => recipe.name)
              .toSet());
    }
  }

  Future<Recipe?> findById(int? id) async {
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
