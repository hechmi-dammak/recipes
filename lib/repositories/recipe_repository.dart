import 'package:get/get.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/entities/recipe_category.dart';
import 'package:mekla/repositories/abstracts/repository_service_with_name.dart';
import 'package:mekla/repositories/picture_repository.dart';
import 'package:mekla/repositories/recipe_category_repository.dart';
import 'package:mekla/repositories/recipe_ingredient_repository.dart';
import 'package:mekla/repositories/step_repository.dart';
import 'package:mekla/services/isar_service.dart';

class RecipeRepository extends RepositoryServiceWithName<Recipe> {
  static RecipeRepository get find => Get.find<RecipeRepository>();

  @override
  Future<Recipe?> save(Recipe? element) async {
    if (element == null) {
      return null;
    }
    await _setUniqueName(element);
    return await saveInternal(element);
  }

  @override
  Future<Recipe> saveInternal(Recipe element) async {
    element.name = element.name.trim();
    element.description = element.description?.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.recipes.put(element);
    });
    await PictureRepository.find.save(element.picture.value);
    if (element.category.value?.id == null) {
      await RecipeCategoryRepository.find.save(element.category.value);
    }
    await IsarService.isar.writeTxn(() async {
      await element.picture.save();
      await element.category.save();
      await element.steps.save();
      await element.ingredients.save();
    });
    return element;
  }

  Future<void> _setUniqueName(Recipe recipe) async {
    if (recipe.id == null) {
      recipe.name = await getUniqueNameFrom(recipe.name);
    }
  }

  Future<List<Recipe>> findAllByRecipeCategoryId(int? id) async {
    if (id == null) return [];
    return await IsarService.isar.recipes
        .filter()
        .category((queryBuilder) => queryBuilder.idEqualTo(id))
        .findAll();
  }

  Future<int> deleteByRecipeCategoryId(int recipeCategoryId) async {
    final List<Recipe> recipes =
        await findAllByRecipeCategoryId(recipeCategoryId);

    for (var recipe in recipes) {
      deleteById(recipe.id);
    }
    return recipes.length;
  }

  @override
  Future<bool> beforeDelete(int id) async {
    await StepRepository.find.deleteByRecipeId(id);
    await RecipeIngredientRepository.find.deleteByRecipeId(id);
    return true;
  }

  @override
  Future<void> replaceOriginalItemValues(Recipe original, Recipe tmp) {
    throw UnimplementedError();
  }

  @override
  Future<void> replaceTmpItemValues(Recipe original, Recipe tmp) {
    throw UnimplementedError();
  }
}
