import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/database.dart';
import 'package:recipes/service/picture_operations.dart';
import 'package:recipes/service/ingredient_operations.dart';
import 'package:recipes/service/step_operations.dart';

class RecipeOperations {
  static final RecipeOperations instance = RecipeOperations._init();
  RecipeOperations._init();

  final dbProvider = DataBaseRepository.instance;
  final ingredientOperations = IngredientOperations.instance;
  final stepOperations = StepOperations.instance;
  final pictureOperations = PictureOperations.instance;

  Future<Recipe> create(Recipe recipe) async {
    if (recipe.picture != null && recipe.picture!.id == null) {
      recipe.picture = await pictureOperations.create(recipe.picture!);
    }
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
    final id = await db.insert(tableRecipes, recipe.toDatabaseJson(true));
    return recipe.copy(
        id: id,
        ingredients:
            await ingredientOperations.createAll(recipe.ingredients!, id),
        steps: await stepOperations.createAll(recipe.steps!, id));
  }

  Future<Recipe?> read(int? id) async {
    if (id == null) return null;
    final db = await dbProvider.database;
    final maps = await db.query(
      tableRecipes,
      columns: RecipeFields.values,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      Recipe recipe = Recipe.fromDatabaseJson(maps.first);
      recipe.ingredients = await ingredientOperations.readAllByRecipeId(id);
      recipe.steps = await stepOperations.readAllByRecipeId(id);
      recipe.picture = await pictureOperations
          .read(maps.first[RecipeFields.pictureId] as int?);
      recipe.initIngredientsByCategory();
      return recipe;
    }
    return Recipe();
  }

  Future<Recipe> update(Recipe recipe) async {
    if (recipe.id == null) return await create(recipe);
    if (recipe.picture != null && recipe.picture!.id == null) {
      recipe.picture = await pictureOperations.create(recipe.picture!);
    }
    final db = await dbProvider.database;
    db.update(
      tableRecipes,
      recipe.toDatabaseJson(),
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipe.id],
    );
    return recipe.copy(
        ingredients: await ingredientOperations.updateAll(
            recipe.ingredients!, recipe.id),
        steps: await stepOperations.updateAll(recipe.steps!, recipe.id));
  }

  Future<int> delete(int? id) async {
    if (id == null) return 0;
    final db = await dbProvider.database;
    await ingredientOperations.deleteByRecipeId(id);
    await stepOperations.deleteByRecipeId(id);
    return await db.delete(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByIds(List<int?> ids) async {
    final db = await dbProvider.database;
    ids.removeWhere((element) => element == null);
    await ingredientOperations.deleteByRecipeIds(ids);
    await stepOperations.deleteByRecipeIds(ids);
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
            await ingredientOperations.readAllByRecipeId(recipe.id!);
        recipe.steps = await stepOperations.readAllByRecipeId(recipe.id!);
        recipe.picture = await pictureOperations
            .read(recipeJson[RecipeFields.pictureId] as int?);
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
