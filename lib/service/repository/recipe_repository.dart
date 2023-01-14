import 'package:get/get.dart';
import 'package:recipes/exceptions/not_found_exception.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/data_base_provider.dart';
import 'package:recipes/service/repository/ingredient_repository.dart';
import 'package:recipes/service/repository/instruction_repository.dart';
import 'package:recipes/service/repository/picture_repository.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';

class RecipeRepository extends GetxService {
  static RecipeRepository get find => Get.find<RecipeRepository>();

  Future<Recipe> _create(Recipe recipe) async {
    await _setUniqueName(recipe);

    final id = await (await DataBaseProvider.database)
        .insert(tableRecipes, recipe.toJson(database: true, withId: false));
    return recipe.copy(
        id: id,
        ingredients: await IngredientRepository.find
            .saveAll(ingredients: recipe.ingredients, recipeId: id),
        instructions: await InstructionRepository.find
            .saveAll(instructions: recipe.instructions, recipeId: id));
  }

  Future<void> _setUniqueName(Recipe recipe) async {
    final List<Recipe> foundRecipesByName = await findAllByNameLike(recipe.name,
        withPicture: false,
        withCategory: false,
        withIngredients: false,
        withInstructions: false);

    if (foundRecipesByName.isNotEmpty) {
      final setOfNames =
          foundRecipesByName.map((recipe) => recipe.name).toSet();
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
  }

  Future<Recipe?> findById(
    int? id, {
    bool withPicture = true,
    bool withCategory = true,
    bool withIngredients = true,
    bool withInstructions = true,
  }) async {
    if (id == null) return null;
    final queryResult = await (await DataBaseProvider.database).query(
      tableRecipes,
      columns: RecipeFields.values,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
    if (queryResult.isNotEmpty) {
      final Map<String, Object?> recipeJson = queryResult.first;
      return await _processFindElement(recipeJson,
          withPicture: withPicture,
          withCategory: withCategory,
          withIngredients: withIngredients,
          withInstructions: withInstructions);
    }
    return Recipe();
  }

  Future<Recipe> save(Recipe recipe) async {
    if (recipe.picture != null && recipe.picture!.id == null) {
      recipe.picture = await PictureRepository.find.save(recipe.picture!);
    }
    if (recipe.category != null && recipe.category!.id == null) {
      recipe.category =
          await RecipeCategoryRepository.find.save(recipe.category!);
    }
    if (recipe.id == null) return await _create(recipe);

    final Recipe? oldRecipe = await findById(recipe.id!);
    if (oldRecipe == null) {
      throw NotFoundException('recipe with id:${recipe.id} not found');
    }
    final List<Ingredient> ingredients = await IngredientRepository.find
        .saveAll(
            oldIngredients: oldRecipe.ingredients,
            ingredients: recipe.ingredients,
            recipeId: recipe.id);
    final List<Instruction> instructions = await InstructionRepository.find
        .saveAll(
            oldInstructions: oldRecipe.instructions,
            instructions: recipe.instructions,
            recipeId: recipe.id);
    (await DataBaseProvider.database).update(
      tableRecipes,
      recipe.toJson(database: true),
      where: '${RecipeFields.id} = ?',
      whereArgs: [recipe.id],
    );
    return recipe.copy(ingredients: ingredients, instructions: instructions);
  }

  Future<int> deleteById(int? id) async {
    if (id == null) return 0;
    await IngredientRepository.find.deleteByRecipeId(id);
    await InstructionRepository.find.deleteByRecipeId(id);
    return await (await DataBaseProvider.database).delete(
      tableRecipes,
      where: '${RecipeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Recipe>> findAll({
    bool withPicture = true,
    bool withCategory = true,
    bool withIngredients = true,
    bool withInstructions = true,
  }) async {
    final queryResult = await (await DataBaseProvider.database).query(
      tableRecipes,
      columns: RecipeFields.values,
    );
    return await _processFindAllResult(queryResult,
        withPicture: withPicture,
        withCategory: withCategory,
        withIngredients: withIngredients,
        withInstructions: withInstructions);
  }

  Future<List<Recipe>> findAllByNameLike(
    String name, {
    bool withPicture = true,
    bool withCategory = true,
    bool withIngredients = true,
    bool withInstructions = true,
  }) async {
    final queryResult = await (await DataBaseProvider.database).query(
      tableRecipes,
      columns: RecipeFields.values,
      where: "${RecipeFields.name} REGEXP '^${RegExp.escape(name)}_?[0-9]*\$'",
    );
    return await _processFindAllResult(queryResult,
        withPicture: withPicture,
        withCategory: withCategory,
        withIngredients: withIngredients,
        withInstructions: withInstructions);
  }

  Future<int> deleteByRecipeCategoryId(int recipeCategoryId) async {
    return await (await DataBaseProvider.database).delete(
      tableRecipes,
      where: '${RecipeFields.categoryId} = ?',
      whereArgs: [recipeCategoryId],
    );
  }

  Future<List<Recipe>> _processFindAllResult(
      List<Map<String, Object?>> queryResult,
      {required bool withPicture,
      required bool withCategory,
      required bool withIngredients,
      required bool withInstructions}) async {
    final List<Recipe> recipes = [];

    if (queryResult.isNotEmpty) {
      for (Map<String, Object?> recipeJson in queryResult) {
        recipes.add(await _processFindElement(recipeJson,
            withPicture: withPicture,
            withCategory: withCategory,
            withIngredients: withIngredients,
            withInstructions: withInstructions));
      }
    }
    return recipes;
  }

  Future<Recipe> _processFindElement(Map<String, Object?> recipeJson,
      {required bool withPicture,
      required bool withCategory,
      required bool withIngredients,
      required bool withInstructions}) async {
    final Recipe recipe = Recipe.fromJson(recipeJson, database: true);
    if (withPicture) {
      recipe.picture = await PictureRepository.find.findById(
        recipeJson[RecipeFields.pictureId] as int?,
      );
    }
    if (withCategory) {
      recipe.category = await RecipeCategoryRepository.find.findById(
        recipeJson[RecipeFields.categoryId] as int?,
      );
    }
    if (withIngredients) {
      recipe.ingredients =
          await IngredientRepository.find.findAllByRecipeId(recipe.id!);
    }
    if (withInstructions) {
      recipe.instructions =
          await InstructionRepository.find.findAllByRecipeId(recipe.id!);
    }
    return recipe;
  }
}
