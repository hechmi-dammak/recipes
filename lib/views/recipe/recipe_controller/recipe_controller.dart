import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorator/decorators.dart';
import 'package:recipes/service/repository/recipe_ingredient_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/service/repository/step_repository.dart';
import 'package:recipes/views/recipe/models/recipe_ingredient_pm_recipe.dart';
import 'package:recipes/views/recipe/models/recipe_pm_recipe.dart';
import 'package:recipes/views/recipe/models/step_pm_recipe.dart';
import 'package:recipes/widgets/common/snack_bar.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_ingredient_controller.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_step_controller.dart';
import 'package:recipes/widgets/project/upsert_element/upsert_element_dialog.dart';

part 'ingredient_recipe_controller_part.dart';
part 'step_recipe_controller_part.dart';

class RecipeController extends BaseController
    with
        LoadingDecorator,
        DataFetchingDecorator,
        SelectionDecorator,
        GetSingleTickerProviderStateMixin {
  RecipeController({required this.recipeId});

  static RecipeController get find => Get.find<RecipeController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
  }

  final int recipeId;
  RecipePMRecipe? recipe;
  final int servings = 4;
  late TabController tabController;

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipe()]);
  }

  @override
  void setSelectAllValue([bool value = false]) {
    if (recipe == null) return;
    for (var step in recipe!.stepList) {
      step.selected = value;
    }
    for (var ingredient in recipe!.ingredientList) {
      ingredient.selected = value;
    }
    super.setSelectAllValue(value);
  }

  @override
  bool get selectionIsActiveFallBack {
    if (recipe == null) return false;
    return recipe!.stepList.any((step) => step.selected) ||
        recipe!.ingredientList.any((ingredient) => ingredient.selected);
  }

  @override
  bool get allItemsSelectedFallBack {
    if (recipe == null) return false;

    return recipe!.stepList.every((step) => step.selected) &
        recipe!.ingredientList.every((ingredient) => ingredient.selected);
  }

  @override
  int get selectionCount =>
      getSelectedSteps().length + getSelectedIngredients().length;

  Future<void> fetchRecipe() async {
    final recipe = await RecipeRepository.find.findById(recipeId);
    if (recipe != null) {
      this.recipe = RecipePMRecipe(recipe: recipe);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    tabController.index = index;
    update();
  }

  void editItem() {
    editIngredient();
    editStep();
  }

  Future<void> deleteSelectedItems() async {
    loading = true;
    await deleteSelectedIngredients();
    await deleteSelectedSteps();
    await fetchData();
    CustomSnackBar.success('Selected Items were deleted.'.tr);
  }
}