part of 'recipe_controller.dart';

extension IngredientRecipeController on RecipeController {
  int get _ingredientSelectionCount => _selectedIngredients.length;

  Iterable<RecipeIngredientPMRecipe> get _selectedIngredients {
    if (recipe == null) return const Iterable<RecipeIngredientPMRecipe>.empty();
    return recipe!.ingredientList.where((ingredient) => ingredient.selected);
  }

  Future<void> _addIngredient() async {
    final created = await UpsertElementDialog<UpsertRecipeIngredientController>(
      controller: UpsertRecipeIngredientController(
          recipeId: recipeId, servings: servings),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> _editIngredient() async {
    if (_ingredientSelectionCount != 1) return;
    final created = await UpsertElementDialog<UpsertRecipeIngredientController>(
      controller: UpsertRecipeIngredientController(
          recipeId: recipeId,
          servings: servings,
          id: _selectedIngredients.first.id),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> _deleteSelectedIngredients() async {
    for (RecipeIngredientPMRecipe ingredient in _selectedIngredients) {
      await RecipeIngredientRepository.find.deleteById(ingredient.id!);
    }
  }
}
