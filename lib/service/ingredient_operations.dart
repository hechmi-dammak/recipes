import 'package:recipes/models/ingredient.dart';
import 'package:recipes/service/database.dart';

class IngredientOperations {
  static final IngredientOperations instance = IngredientOperations._init();
  IngredientOperations._init();

  final dbProvider = DataBaseRepository.instance;
  Future<Ingredient> create(Ingredient ingredient, int? recipeId) async {
    final db = await dbProvider.database;

    final id =
        await db.insert(tableIngredients, ingredient.toDatabaseJson(recipeId));
    return ingredient.copy(id: id);
  }

  Future<Ingredient> read(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query(
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

  Future<int> update(Ingredient ingredient) async {
    final db = await dbProvider.database;

    return db.update(
      tableIngredients,
      ingredient.toJson(),
      where: '${IngredientFields.id} = ?',
      whereArgs: [ingredient.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbProvider.database;

    return await db.delete(
      tableIngredients,
      where: '${IngredientFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Ingredient>> readAllByRecipeId(int recipeId) async {
    final db = await dbProvider.database;
    List<Ingredient> ingredients = [];
    final maps = await db.query(
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
    final db = await dbProvider.database;
    List<Ingredient> ingredients = [];
    final maps = await db.query(
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
    final db = await dbProvider.database;
    List<String> values = [];
    final maps = await db.query(tableIngredients,
        distinct: true, columns: [attribute], where: "$attribute is not null");
    if (maps.isNotEmpty) {
      for (var ingredient in maps) {
        values.add(ingredient[attribute].toString());
      }
    }
    return values;
  }

  Future<int> deleteByRecipeId(int recipeId) async {
    final db = await dbProvider.database;

    return await db.delete(
      tableIngredients,
      where: '${IngredientFields.recipeId} = ?',
      whereArgs: [recipeId],
    );
  }

  Future<int> deleteByRecipeIds(List<int> recipeIds) async {
    final db = await dbProvider.database;

    return await db.delete(
      tableIngredients,
      where: '${IngredientFields.recipeId} in (?)',
      whereArgs: [recipeIds],
    );
  }

  Future<List<Ingredient>> createAll(
      List<Ingredient>? ingredients, int? recipeId) async {
    if (ingredients == null || ingredients.isEmpty) return [];
    final db = await dbProvider.database;
    final List<Ingredient> result = [];
    for (var ingredient in ingredients) {
      ingredient.id = null;
      final id = await db.insert(
          tableIngredients, ingredient.toDatabaseJson(recipeId));
      result.add(ingredient.copy(id: id));
    }
    return result;
  }

  Future<List<Ingredient>> updateAll(
      List<Ingredient>? ingredients, int? recipeId) async {
    final List<Ingredient> result = [];
    if (ingredients == null || ingredients.isEmpty) return result;
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      for (var ingredient in ingredients) {
        if (ingredient.id == null) {
          final id = await txn.insert(
              tableIngredients, ingredient.toDatabaseJson(recipeId));
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
