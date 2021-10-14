import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/database.dart';
import 'package:recipes/service/ingredient_operations.dart';
import 'package:recipes/service/step_operations.dart';

class RecipeOperations {
  static final RecipeOperations instance = RecipeOperations._init();
  RecipeOperations._init();

  final dbProvider = DataBaseRepository.instance;
  final ingredientOpertations = IngredientOperations.instance;
  final stepOpertations = StepOperations.instance;
  Future<Recipe> create(Recipe recipe) async {
    final db = await dbProvider.database;
    List<Recipe> foundRecipesByName = await readAllByName(recipe.name);
    if (foundRecipesByName.isNotEmpty) {
      final setOfNames = Set<String>.from(
          foundRecipesByName.map<String>((recipe) => recipe.name));
      var index = 1;
      while (true) {
        if (setOfNames.contains('${recipe.name}_$index')) {
          index++;
        } else {
          recipe.name += '_$index';
          break;
        }
      }
    }
    final id = await db.insert(tableRecipes, recipe.toDatabaseJson());
    return recipe.copy(
        id: id,
        ingredients:
            await ingredientOpertations.createAll(recipe.ingredients!, id),
        steps: await stepOpertations.createAll(recipe.steps!, id));
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
      recipe.steps = await stepOpertations.readAllByRecipeId(id);
      recipe.initIngredientsByCategory();
      return recipe;
    }
    return Recipe();
  }

  Future<Recipe> update(Recipe recipe) async {
    final db = await dbProvider.database;
    if (recipe.id == null) {
      throw Exception("recipe Id is null");
    }
    db.update(
      tableRecipes,
      recipe.toDatabaseJson(),
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipe.id],
    );
    return recipe.copy(
        ingredients: await ingredientOpertations.updateAll(
            recipe.ingredients!, recipe.id),
        steps: await stepOpertations.updateAll(recipe.steps!, recipe.id));
  }

  Future<int> delete(int id) async {
    final db = await dbProvider.database;
    await ingredientOpertations.deleteByRecipeId(id);
    await stepOpertations.deleteByRecipeId(id);
    return await db.delete(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByIds(List<int> ids) async {
    final db = await dbProvider.database;
    await ingredientOpertations.deleteByRecipeIds(ids);
    await stepOpertations.deleteByRecipeIds(ids);
    return await db.delete(
      tableRecipes,
      where: '${RecipeFields.id} in (?)',
      whereArgs: [ids],
    );
  }

  Future<List<Recipe>> createAll(List<Recipe> recipes) async {
    final List<Recipe> result = [];
    for (var recipe in recipes) {
      result.add(await create(recipe));
    }
    return result;
  }

  Future<List<String>> getAllCategories() async {
    final db = await dbProvider.database;
    List<String> categories = [];
    final maps = await db.query(
      tableRecipes,
      distinct: true,
      where: "${RecipeFields.category} is not null",
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
        recipe.steps = await stepOpertations.readAllByRecipeId(recipe.id!);
        recipe.initIngredientsByCategory();
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
