part of 'recipe_controller.dart';

extension IngredientRecipeController on RecipeController {
  int get ingredientSelectionCount => getSelectedIngredients().length;

  Iterable<RecipeIngredientPMRecipe> getSelectedIngredients() {
    if (recipe == null) return const Iterable<RecipeIngredientPMRecipe>.empty();
    return recipe!.ingredientList.where((ingredient) => ingredient.selected);
  }

  Future<void> addIngredient() async {
    final created = await UpsertElementDialog<UpsertIngredientController>(
      controller: UpsertIngredientController(recipeId: recipeId),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editIngredient() async {
    if (ingredientSelectionCount != 1) return;
    final created = await UpsertElementDialog<UpsertIngredientController>(
      controller: UpsertIngredientController(
          recipeId: recipeId,
          id: getSelectedIngredients().first.id,
          order: recipe!.steps.length),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  void selectIngredient(RecipeIngredientPMRecipe ingredient) {
    ingredient.selected = !ingredient.selected;
    updateSelection();
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
