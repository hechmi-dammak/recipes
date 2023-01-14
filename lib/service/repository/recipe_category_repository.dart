import 'package:get/get.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/service/data_base_provider.dart';
import 'package:recipes/service/repository/picture_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';

class RecipeCategoryRepository extends GetxService {
  static RecipeCategoryRepository get find =>
      Get.find<RecipeCategoryRepository>();

  Future<RecipeCategory> _create(RecipeCategory recipeCategory) async {
    await _setUniqueName(recipeCategory);

    final id = await (await DataBaseProvider.database).insert(
        tableRecipesCategories,
        recipeCategory.toJson(database: true, withId: false));
    return recipeCategory.copy(
      id: id,
    );
  }

  Future<void> _setUniqueName(RecipeCategory recipeCategory) async {
    final List<RecipeCategory> foundRecipesCategoriesByName =
        await findAllByNameLike(recipeCategory.name, withPicture: false);
    if (foundRecipesCategoriesByName.isNotEmpty) {
      final setOfNames = foundRecipesCategoriesByName
          .map((recipeCategory) => recipeCategory.name)
          .toSet();
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

  Future<RecipeCategory> save(
    RecipeCategory recipeCategory,
  ) async {
    if (recipeCategory.picture != null && recipeCategory.picture?.id == null) {
      recipeCategory.picture =
          await PictureRepository.find.save(recipeCategory.picture!);
    }
    if (recipeCategory.id == null) {
      return await _create(recipeCategory);
    }
    (await DataBaseProvider.database).update(
      tableRecipesCategories,
      recipeCategory.toJson(database: true),
      where: '${RecipeCategoryFields.id} = ?',
      whereArgs: [recipeCategory.id],
    );
    return recipeCategory.copy();
  }

  Future<int> deleteById(int? id) async {
    if (id == null) return 0;
    await RecipeRepository.find.deleteByRecipeCategoryId(id);
    return await (await DataBaseProvider.database).delete(
      tableRecipesCategories,
      where: '${RecipeCategoryFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<RecipeCategory?> findById(
    int? id, {
    withPicture = true,
  }) async {
    if (id == null) return null;
    final queryResult = await (await DataBaseProvider.database).query(
      tableRecipesCategories,
      columns: RecipeCategoryFields.values,
      where: '${RecipeCategoryFields.id} = ?',
      whereArgs: [id],
    );
    if (queryResult.isNotEmpty) {
      final Map<String, Object?> recipeCategoryJson = queryResult.first;
      return await _processFindElement(recipeCategoryJson, withPicture);
    }
    return null;
  }

  Future<List<RecipeCategory>> findAll({
    withPicture = true,
  }) async {
    final queryResult = await (await DataBaseProvider.database).query(
      tableRecipesCategories,
      columns: RecipeCategoryFields.values,
    );
    return await _processFindAllResult(queryResult, withPicture);
  }

  Future<List<RecipeCategory>> findAllByNameLike(
    String name, {
    withPicture = true,
  }) async {
    final queryResult = await (await DataBaseProvider.database).query(
      tableRecipesCategories,
      columns: RecipeCategoryFields.values,
      where:
          "${RecipeCategoryFields.name} REGEXP '^${RegExp.escape(name)}_?[0-9]*\$'",
    );
    return await _processFindAllResult(queryResult, withPicture);
  }

  Future<List<RecipeCategory>> _processFindAllResult(
    List<Map<String, Object?>> queryResult,
    bool withPicture,
  ) async {
    final List<RecipeCategory> recipesCategories = [];

    if (queryResult.isNotEmpty) {
      for (Map<String, Object?> recipeCategoryJson in queryResult) {
        recipesCategories
            .add(await _processFindElement(recipeCategoryJson, withPicture));
      }
    }
    return recipesCategories;
  }

  Future<RecipeCategory> _processFindElement(
    Map<String, Object?> recipeCategoryJson,
    bool withPicture,
  ) async {
    final RecipeCategory recipeCategory =
        RecipeCategory.fromJson(recipeCategoryJson, database: true);
    if (withPicture) {
      recipeCategory.picture = await PictureRepository.find.findById(
        recipeCategoryJson[RecipeCategoryFields.pictureId] as int?,
      );
    }
    return recipeCategory;
  }
}
