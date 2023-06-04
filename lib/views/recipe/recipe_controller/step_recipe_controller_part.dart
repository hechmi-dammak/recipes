part of 'recipe_controller.dart';

extension StepRecipeController on RecipeController {
  int get _stepSelectionCount => _selectedSteps.length;

  Iterable<StepPMRecipe> get _selectedSteps {
    return stepList.where((step) => step.selected);
  }

  Future<void> _addStep() async {
    final created = await UpsertElementDialog<UpsertStepController>(
      init: UpsertStepController(recipeId: recipeId),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> _editStep() async {
    if (_stepSelectionCount != 1) return;
    final created = await UpsertElementDialog<UpsertStepController>(
      init:
          UpsertStepController(recipeId: recipeId, id: _selectedSteps.first.id),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> _deleteSelectedSteps() async {
    for (StepPMRecipe step in _selectedSteps) {
      await StepRepository.find.deleteById(step.id!);
    }
  }
}
