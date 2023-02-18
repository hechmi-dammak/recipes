part of 'recipe_controller.dart';

extension StepRecipeController on RecipeController {
  int get stepSelectionCount => getSelectedSteps().length;

  Iterable<StepPMRecipe> getSelectedSteps() {
    if (recipe == null) return const Iterable<StepPMRecipe>.empty();
    return recipe!.stepList.where((step) => step.selected);
  }

  Future<void> addStep() async {
    final created = await UpsertElementDialog<UpsertStepController>(
      controller: UpsertStepController(recipeId: recipeId),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editStep() async {
    if (selectionCount != 1 && stepSelectionCount != 1) return;
    final created = await UpsertElementDialog<UpsertStepController>(
      controller: UpsertStepController(
          recipeId: recipeId, id: getSelectedSteps().first.id),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  void selectStep(StepPMRecipe step) {
    step.selected = !step.selected;
    updateSelection();
  }

  void useStep(StepPMRecipe step) {
    step.used = !step.used;
    updateSelection();
  }

  Future<void> deleteSelectedSteps() async {
    for (StepPMRecipe step in getSelectedSteps()) {
      await StepRepository.find.deleteById(step.id!);
    }
  }
}
