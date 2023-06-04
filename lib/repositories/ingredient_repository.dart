import 'package:get/get.dart';
import 'package:mekla/models/entities/ingredient.dart';
import 'package:mekla/models/entities/recipe_ingredient.dart';
import 'package:mekla/repositories/abstracts/repository_service_with_name.dart';
import 'package:mekla/repositories/picture_repository.dart';
import 'package:mekla/repositories/recipe_ingredient_repository.dart';
import 'package:mekla/services/isar_service.dart';

class IngredientRepository extends RepositoryServiceWithName<Ingredient> {
  static IngredientRepository get find => Get.find<IngredientRepository>();

  @override
  Future<Ingredient?> save(Ingredient? element) async {
    if (element == null) {
      return null;
    }
    await replaceWithSameName(element);
    return await saveInternal(element);
  }

  @override
  Future<Ingredient> saveInternal(Ingredient element) async {
    element.name = element.name.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.ingredients.put(element);
    });
    await PictureRepository.find.save(element.picture.value);
    await IsarService.isar.writeTxn(() async {
      await element.picture.save();
    });
    return element;
  }

  @override
  Future<bool> beforeDelete(int id) async {
    await RecipeIngredientRepository.find.deleteByIngredientId(id);

    return true;
  }

  @override
  Future<void> replaceOriginalItemValues(
      Ingredient original, Ingredient tmp) async {
    original.picture.value ??= tmp.picture.value;
  }

  @override
  Future<void> replaceTmpItemValues(Ingredient original, Ingredient tmp) async {
    final List<RecipeIngredient> recipeIngredients =
        original.recipeIngredients.toList();
    await IsarService.isar.writeTxn(() async {
      for (RecipeIngredient recipeIngredient in recipeIngredients) {
        recipeIngredient.ingredient.value = tmp;
        await recipeIngredient.ingredient.save();
      }
    });
    tmp.picture.value = original.picture.value ?? tmp.picture.value;
  }
}
