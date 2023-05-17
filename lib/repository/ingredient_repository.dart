import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/ingredient.dart';
import 'package:mekla/models/isar_models/recipe_ingredient.dart';
import 'package:mekla/repository/picture_repository.dart';
import 'package:mekla/repository/recipe_ingredient_repository.dart';
import 'package:mekla/repository/repository_service.dart';
import 'package:mekla/service/isar_service.dart';

class IngredientRepository extends RepositoryService<Ingredient> {
  static IngredientRepository get find => Get.find<IngredientRepository>();

  @override
  Future<Ingredient> save(Ingredient element) async {
    await _replaceWithSameName(element);
    return await _save(element);
  }

  Future<Ingredient> _save(Ingredient ingredient) async {
    ingredient.name = ingredient.name.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.ingredients.put(ingredient);
    });
    if (ingredient.picture.value != null &&
        ingredient.picture.value?.id == null) {
      await PictureRepository.find.save(ingredient.picture.value!);
    }
    await IsarService.isar.writeTxn(() async {
      await ingredient.picture.save();
    });

    return ingredient;
  }

  Future<void> _replaceWithSameName(Ingredient ingredient) async {
    final List<Ingredient> ingredients = await IsarService.isar.ingredients
        .filter()
        .nameEqualTo(ingredient.name.trim(), caseSensitive: false)
        .findAll();
    if (ingredients.isNotEmpty) {
      final Ingredient tmpIngredient = ingredients.first;
      if (ingredient.id != null) {
        final List<RecipeIngredient> recipeIngredients =
            ingredient.recipeIngredients.toList();
        await IsarService.isar.writeTxn(() async {
          for (RecipeIngredient recipeIngredient in recipeIngredients) {
            recipeIngredient.ingredient.value = tmpIngredient;
            recipeIngredient.ingredient.save();
          }
        });
        tmpIngredient.picture.value =
            ingredient.picture.value ?? tmpIngredient.picture.value;
        _save(tmpIngredient);
        deleteById(ingredient.id);
      }
      ingredient.id = tmpIngredient.id;
      ingredient.picture.value ??= tmpIngredient.picture.value;
    }
  }

  @override
  Future<bool> beforeDelete(int id) async {
    await RecipeIngredientRepository.find.deleteByIngredientId(id);

    return true;
  }
}
