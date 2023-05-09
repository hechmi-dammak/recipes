import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/ingredient_category.dart';
import 'package:recipes/service/isar_service.dart';

class IngredientCategoryRepository extends GetxService {
  static IngredientCategoryRepository get find =>
      Get.find<IngredientCategoryRepository>();

  Future<IngredientCategory> save(IngredientCategory ingredientCategory) async {
    await _replaceWithSameName(ingredientCategory);
    return await _save(ingredientCategory);
  }

  Future<IngredientCategory> _save(
      IngredientCategory ingredientCategory) async {
    ingredientCategory.name=ingredientCategory.name.trim();
    await IsarService.isar.writeTxn(() async =>
        await IsarService.isar.ingredientCategories.put(ingredientCategory));
    return ingredientCategory;
  }

  Future<void> _replaceWithSameName(
      IngredientCategory ingredientCategory) async {
    if (ingredientCategory.id == null) {
      final List<IngredientCategory> ingredientCategories = await IsarService
          .isar.ingredientCategories
          .filter()
          .nameEqualTo(ingredientCategory.name.trim(), caseSensitive: false)
          .findAll();
      if (ingredientCategories.isNotEmpty) {
        ingredientCategory.id = ingredientCategories.first.id;
      }
    }
  }

  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.ingredientCategories.delete(id));
  }

  Future<IngredientCategory?> findById(int? id) async {
    if (id == null) return null;
    return IsarService.isar.ingredientCategories.get(id);
  }

  Future<List<IngredientCategory>> findAll() async {
    return await IsarService.isar.ingredientCategories.where().findAll();
  }

  Future<List<IngredientCategory>> findAllByNameStartWith(String name) async {
    return await IsarService.isar.ingredientCategories
        .filter()
        .nameStartsWith(name)
        .findAll();
  }
}
