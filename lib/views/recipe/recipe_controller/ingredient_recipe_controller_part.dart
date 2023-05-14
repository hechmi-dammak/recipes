part of 'recipe_controller.dart';

extension IngredientRecipeController on RecipeController {
  int get ingredientSelectionCount => getSelectedIngredients().length;

  Iterable<RecipeIngredientPMRecipe> getSelectedIngredients() {
    if (recipe == null) return const Iterable<RecipeIngredientPMRecipe>.empty();
    return recipe!.ingredientList.where((ingredient) => ingredient.selected);
  }

  Future<void> addIngredient() async {
    final created = await UpsertElementDialog<UpsertRecipeIngredientController>(
      controller:
          UpsertRecipeIngredientController(recipeId: recipeId, servings: servings),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editIngredient() async {
    if (ingredientSelectionCount != 1) return;
    final created = await UpsertElementDialog<UpsertRecipeIngredientController>(
      controller: UpsertRecipeIngredientController(
          recipeId: recipeId,
          servings: servings,
          id: getSelectedIngredients().first.id),
    ).show(false);
    if (created ?? false) await fetchData();
  }



  void useIngredient(RecipeIngredientPMRecipe ingredient) {
    ingredient.used = !ingredient.used;
    updateSelection();
  }

  Future<void> deleteSelectedIngredients() async {
    for (RecipeIngredientPMRecipe ingredient in getSelectedIngredients()) {
      await RecipeIngredientRepository.find.deleteById(ingredient.id!);
    }
  }
}
