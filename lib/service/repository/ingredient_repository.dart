import 'package:get/get.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/service/data_base_provider.dart';

class IngredientRepository extends GetxService {
  static IngredientRepository get find => Get.find<IngredientRepository>();

  Future<Ingredient> create(Ingredient ingredient, int? recipeId) async {
    final id = await (await DataBaseProvider.database)
        .insert(tableIngredients, ingredient.toDatabaseJson(recipeId, true));
    return ingredient.copy(id: id);
  }

  Future<Ingredient?> read(int? id) async {
    if (id == null) return null;

    final maps = await (await DataBaseProvider.database).query(
      tableIngredients,
      columns: IngredientFields.values,
      where: '${IngredientFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Ingredient.fromDatabaseJson(maps.first);
    }
    return Ingredient();
  }

  Future<Ingredient> update(Ingredient ingredient, int? recipeId) async {
    if (ingredient.id == null) return await create(ingredient, recipeId);

    (await DataBaseProvider.database).update(
      tableIngredients,
      ingredient.toJson(),
      where: '${IngredientFields.id} = ?',
      whereArgs: [ingredient.id],
    );
    return ingredient;
  }

  Future<int> delete(int? id) async {
    if (id == null) return 0;

    return await (await DataBaseProvider.database).delete(
      tableIngredients,
      where: '${IngredientFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Ingredient>> readAllByRecipeId(int? recipeId) async {
    if (recipeId == null) {
      return [];
    }

    final List<Ingredient> ingredients = [];
    final maps = await (await DataBaseProvider.database).query(
      tableIngredients,
      columns: IngredientFields.values,
      where: '${IngredientFields.recipeId} = ?',
      whereArgs: [recipeId],
    );
    if (maps.isNotEmpty) {
      for (var ingredient in maps) {
        ingredients.add(Ingredient.fromDatabaseJson(ingredient));
      }
    }
    return ingredients;
  }

  Future<List<Ingredient>> readAll() async {
    final List<Ingredient> ingredients = [];
    final maps = await (await DataBaseProvider.database).query(
      tableIngredients,
      columns: IngredientFields.values,
    );
    if (maps.isNotEmpty) {
      for (var ingredient in maps) {
        ingredients.add(Ingredient.fromDatabaseJson(ingredient));
      }
    }
    return ingredients;
  }

  Future<List<String>> getAllValuesOfAttribute(String attribute) async {
    final List<String> values = [];
    final maps = await (await DataBaseProvider.database).query(tableIngredients,
        distinct: true, columns: [attribute], where: '$attribute is not null');
    if (maps.isNotEmpty) {
      for (var ingredient in maps) {
        values.add(ingredient[attribute].toString());
      }
    }
    return values;
  }

  Future<int> deleteByRecipeId(int recipeId) async {
    return await (await DataBaseProvider.database).delete(
      tableIngredients,
      where: '${IngredientFields.recipeId} = ?',
      whereArgs: [recipeId],
    );
  }

  Future<int> deleteByRecipeIds(List<int?> recipeIds) async {
    recipeIds.removeWhere((element) => element == null);
    return await (await DataBaseProvider.database).delete(
      tableIngredients,
      where: '${IngredientFields.recipeId} in (?)',
      whereArgs: [recipeIds],
    );
  }

  Future<List<Ingredient>> createAll(
      List<Ingredient>? ingredients, int? recipeId) async {
    if (ingredients == null || ingredients.isEmpty) return [];
    final List<Ingredient> result = [];
    for (var ingredient in ingredients) {
      ingredient.id = null;
      final id = await (await DataBaseProvider.database)
          .insert(tableIngredients, ingredient.toDatabaseJson(recipeId, true));
      result.add(ingredient.copy(id: id));
    }
    return result;
  }

  Future<List<Ingredient>> updateAll(
      List<Ingredient>? ingredients, int? recipeId) async {
    final List<Ingredient> result = [];
    if (ingredients == null || ingredients.isEmpty) return result;
    await (await DataBaseProvider.database).transaction((txn) async {
      for (var ingredient in ingredients) {
        if (ingredient.id == null) {
          final id = await txn.insert(
              tableIngredients, ingredient.toDatabaseJson(recipeId, true));
          result.add(ingredient.copy(id: id));
        } else {
          txn.update(
            tableIngredients,
            ingredient.toDatabaseJson(recipeId),
            where: '${IngredientFields.id} = ?',
            whereArgs: [ingredient.id],
          );
          result.add(ingredient);
        }
      }
    });
    return result;
  }
}
