import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/database.dart';
import 'package:recipes/service/ingredient_operations.dart';

class RecipeOperations {
  static final RecipeOperations instance = RecipeOperations._init();
  RecipeOperations._init();

  final dbProvider = DataBaseRepository.instance;
  final ingredientOpertations = IngredientOperations.instance;
  Future<Recipe> create(Recipe recipe) async {
    final db = await dbProvider.database;
    final id = await db.insert(tableRecipes, recipe.toDatabaseJson());
    return recipe.copy(id: id);
  }

  Future<Recipe> read(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query(
      tableRecipes,
      columns: RecipeFields.values,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      Recipe recipe = Recipe.fromDatabaseJson(maps.first);
      recipe.ingredients = await ingredientOpertations.readAllByRecipeId(id);
      recipe.initIngredientsByCategory();
      return recipe;
    }
    return Recipe();
  }

  Future<int> update(Recipe recipe) async {
    final db = await dbProvider.database;

    return db.update(
      tableRecipes,
      recipe.toJson(),
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbProvider.database;
    await ingredientOpertations.deleteByRecipeId(id);
    return await db.delete(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByIds(List<int> ids) async {
    int count = 0;
    for (var id in ids) {
      count += await delete(id);
    }
    return count;
  }

  Future<List<Recipe>> createAll(List<Recipe> recipes) async {
    final db = await dbProvider.database;
    final List<Recipe> result = [];
    for (var recipe in recipes) {
      List<Recipe> foundRecipesByName = await readAllByName(recipe.name);
      if (foundRecipesByName.isNotEmpty) {
        Set<String> setOfNames =
            Set.from(foundRecipesByName.map((recipe) => recipe.name));
        int index = 1;
        while (true) {
          if (setOfNames.contains(recipe.name + '_' + index.toString())) {
            index++;
          } else {
            recipe.name += '_' + index.toString();
            break;
          }
        }
      }
      recipe.id = null;
      final id = await db.insert(tableRecipes, recipe.toDatabaseJson());

      final List<Ingredient> ingredients = recipe.ingredients == null
          ? []
          : await ingredientOpertations.createAll(recipe.ingredients!, id);
      recipe = recipe.copy(id: id, ingredients: ingredients);
      recipe.initIngredientsByCategory();
      result.add(recipe);
    }
    return result;
  }

  Future<List<String>> getAllCategories() async {
    final db = await dbProvider.database;
    List<String> categories = [];
    final maps = await db.query(
      tableRecipes,
      distinct: true,
      columns: [RecipeFields.category],
    );
    if (maps.isNotEmpty) {
      for (var recipe in maps) {
        categories.add(recipe[RecipeFields.category].toString());
      }
    }
    return categories;
  }

  Future<List<Recipe>> readAll() async {
    final db = await dbProvider.database;
    List<Recipe> recipes = [];
    final maps = await db.query(
      tableRecipes,
      columns: RecipeFields.values,
    );
    if (maps.isNotEmpty) {
      for (var recipeJson in maps) {
        Recipe recipe = Recipe.fromDatabaseJson(recipeJson);
        recipe.ingredients =
            await ingredientOpertations.readAllByRecipeId(recipe.id!);
        recipe.initIngredientsByCategory();
        recipes.add(recipe);
      }
    }
    return recipes;
  }

  Future<List<Recipe>> readAllForList() async {
    final db = await dbProvider.database;
    List<Recipe> recipes = [];
    final maps = await db.query(
      tableRecipes,
      columns: RecipeFields.values,
    );
    if (maps.isNotEmpty) {
      for (var recipeJson in maps) {
        Recipe recipe = Recipe.fromDatabaseJson(recipeJson);
        recipes.add(recipe);
      }
    }
    return recipes;
  }

  Future<List<Recipe>> readAllByName(String name) async {
    final db = await dbProvider.database;
    List<Recipe> recipes = [];
    final maps = await db.query(
      tableRecipes,
      columns: RecipeFields.values,
      where: "${RecipeFields.name} REGEXP '^" +
          RegExp.escape(name) +
          "_?[0-9]*\$'",
    );
    if (maps.isNotEmpty) {
      for (var recipeJson in maps) {
        Recipe recipe = Recipe.fromDatabaseJson(recipeJson);
        recipes.add(recipe);
      }
    }
    return recipes;
  }
}
