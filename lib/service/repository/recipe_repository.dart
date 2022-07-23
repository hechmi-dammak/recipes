import 'package:get/get.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/data_base_provider.dart';
import 'package:recipes/service/repository/ingredient_repository.dart';
import 'package:recipes/service/repository/instruction_repository.dart';
import 'package:recipes/service/repository/picture_repository.dart';

class RecipeRepository extends GetxService {
  static RecipeRepository get find => Get.find<RecipeRepository>();

  Future<Recipe> create(Recipe recipe) async {
    if (recipe.picture != null && recipe.picture!.id == null) {
      recipe.picture = await PictureRepository.find.create(recipe.picture!);
    }
    final List<Recipe> foundRecipesByName = await readAllByName(recipe.name);
    if (foundRecipesByName.isNotEmpty) {
      final setOfNames =
          foundRecipesByName.map<String>((recipe) => recipe.name).toSet();
      int index = 1;
      while (setOfNames.contains('${recipe.name}_$index')) {
        index++;
      }
      recipe.name += '_$index';
    }
    final id = await (await DataBaseProvider.database)
        .insert(tableRecipes, recipe.toDatabaseJson(true));
    return recipe.copy(
        id: id,
        ingredients:
            await IngredientRepository.find.createAll(recipe.ingredients, id),
        instructions: await InstructionRepository.find
            .createAll(recipe.instructions, id));
  }

  Future<Recipe?> read(int? id) async {
    if (id == null) return null;
    final maps = await (await DataBaseProvider.database).query(
      tableRecipes,
      columns: RecipeFields.values,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final Recipe recipe = Recipe.fromDatabaseJson(maps.first);
      recipe.ingredients =
          await IngredientRepository.find.readAllByRecipeId(id);
      recipe.instructions =
          await InstructionRepository.find.readAllByRecipeId(id);
      recipe.picture = await PictureRepository.find
          .read(maps.first[RecipeFields.pictureId] as int?);
      return recipe;
    }
    return Recipe();
  }

  Future<Recipe> update(Recipe recipe) async {
    if (recipe.id == null) return await create(recipe);
    if (recipe.picture != null && recipe.picture!.id == null) {
      recipe.picture = await PictureRepository.find.create(recipe.picture!);
    }
    (await DataBaseProvider.database).update(
      tableRecipes,
      recipe.toDatabaseJson(),
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipe.id],
    );
    return recipe.copy(
        ingredients: await IngredientRepository.find
            .updateAll(recipe.ingredients, recipe.id),
        instructions: await InstructionRepository.find
            .updateAll(recipe.instructions, recipe.id));
  }

  Future<int> delete(int? id) async {
    if (id == null) return 0;
    await IngredientRepository.find.deleteByRecipeId(id);
    await InstructionRepository.find.deleteByRecipeId(id);
    return await (await DataBaseProvider.database).delete(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByIds(List<int?> ids) async {
    ids.removeWhere((element) => element == null);
    await IngredientRepository.find.deleteByRecipeIds(ids);
    await InstructionRepository.find.deleteByRecipeIds(ids);
    return await (await DataBaseProvider.database).delete(
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
    final List<String> categories = [];
    final maps = await (await DataBaseProvider.database).query(
      tableRecipes,
      distinct: true,
      where: '${RecipeFields.category} is not null',
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
    final List<Recipe> recipes = [];
    final maps = await (await DataBaseProvider.database).query(
      tableRecipes,
      columns: RecipeFields.values,
    );
    if (maps.isNotEmpty) {
      for (var recipeJson in maps) {
        final Recipe recipe = Recipe.fromDatabaseJson(recipeJson);
        recipe.ingredients =
            await IngredientRepository.find.readAllByRecipeId(recipe.id!);
        recipe.instructions =
            await InstructionRepository.find.readAllByRecipeId(recipe.id!);
        recipe.picture = await PictureRepository.find
            .read(recipeJson[RecipeFields.pictureId] as int?);
        recipes.add(recipe);
      }
    }
    return recipes;
  }

  Future<List<Recipe>> readAllByName(String name) async {
    final List<Recipe> recipes = [];
    final maps = await (await DataBaseProvider.database).query(
      tableRecipes,
      columns: RecipeFields.values,
      where: "${RecipeFields.name} REGEXP '^${RegExp.escape(name)}_?[0-9]*\$'",
    );
    if (maps.isNotEmpty) {
      for (var recipeJson in maps) {
        final Recipe recipe = Recipe.fromDatabaseJson(recipeJson);
        recipes.add(recipe);
      }
    }
    return recipes;
  }
}
