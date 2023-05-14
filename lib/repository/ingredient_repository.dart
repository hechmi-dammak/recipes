import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/ingredient.dart';
import 'package:mekla/repository/picture_repository.dart';
import 'package:mekla/service/isar_service.dart';

class IngredientRepository extends GetxService {
  static IngredientRepository get find => Get.find<IngredientRepository>();

  Future<Ingredient> save(Ingredient ingredient) async {
    await _replaceWithSameName(ingredient);
    return await _save(ingredient);
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
    if (ingredient.id == null) {
      final List<Ingredient> ingredients = await IsarService.isar.ingredients
          .filter()
          .nameEqualTo(ingredient.name.trim(), caseSensitive: false)
          .findAll();
      if (ingredients.isNotEmpty) {
        final Ingredient tmpIngredient = ingredients.first;
        ingredient.id = tmpIngredient.id;
        ingredient.picture.value ??= tmpIngredient.picture.value;
      }
    }
  }

  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.ingredients.delete(id));
  }

  Future<Ingredient?> findById(int? id) async {
    if (id == null) return null;
    return IsarService.isar.ingredients.get(id);
  }

  Future<List<Ingredient>> findAll() async {
    return await IsarService.isar.ingredients.where().findAll();
  }
}
