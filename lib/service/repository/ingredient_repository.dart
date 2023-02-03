import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/service/isar_service.dart';

class IngredientRepository extends GetxService {
  static IngredientRepository get find => Get.find<IngredientRepository>();

  Future<Ingredient> save(Ingredient ingredient) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.ingredients.put(ingredient);
      await ingredient.picture.save();
    });
    return ingredient;
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
